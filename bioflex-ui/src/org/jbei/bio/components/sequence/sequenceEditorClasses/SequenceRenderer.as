package org.jbei.bio.components.sequence.sequenceEditorClasses
{
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    
    import mx.core.UIComponent;
    
    import org.jbei.bio.components.sequence.common.SymbolRenderer;
    import org.jbei.bio.components.utils.SystemUtils;

    /**
     * @author Zinovii Dmytriv
     */
	public class SequenceRenderer extends UIComponent
	{
		private var contentHolder:ContentHolder;
        
        private var _sequenceSymbolRenderer:SymbolRenderer;
        private var _revComSymbolRenderer:SymbolRenderer;
        
        private var _sequenceFontSize:int;
        private var _sequenceFontColor:int;
        private var _revComSequenceFontColor:int;
		
		private var _totalHeight:int = 0;
		private var _totalWidth:int = 0;
		
		private var needsMeasurement:Boolean = false;
        private var sequenceFontChanged:Boolean = false;
		
		// Contructor
		public function SequenceRenderer(contentHolder:ContentHolder)
		{
			super();
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			this.contentHolder = contentHolder;
            
            initializeProperties();
		}
		
		// Properties
		public function get totalHeight():int
		{
			return _totalHeight;
		}
		
		public function get totalWidth():int
		{
			return _totalWidth;
		}
		
        public function get sequenceSymbolRenderer():SymbolRenderer
        {
            return _sequenceSymbolRenderer;
        }
        
        public function get revComSymbolRenderer():SymbolRenderer
        {
            return _revComSymbolRenderer;
        }
        
        public function get sequenceFontSize():int
        {
            return _sequenceFontSize;
        }
        
        public function set sequenceFontSize(value:int):void
        {
            _sequenceFontSize = value;
            
            invalidateProperties();
            
            sequenceFontChanged = true;
        }
            
        public function get sequenceFontColor():int
        {
            return _sequenceFontColor;
        }
        
        public function set sequenceFontColor(value:int):void
        {
            _sequenceFontColor = value;
            
            invalidateProperties();
            
            sequenceFontChanged = true;
        }
        
        public function get revComSequenceFontColor():int
        {
            return _revComSequenceFontColor;
        }
        
        public function set revComSequenceFontColor(value:int):void
        {
            _revComSequenceFontColor = value;
            
            invalidateProperties();
            
            sequenceFontChanged = true;
        }
        
		// Public Methods
		public function update():void
		{
			needsMeasurement = true;
			
			invalidateDisplayList();
		}
		
		// Protected Methods
        protected override function createChildren():void
        {
            super.createChildren();
            
            createSymbolRenderers();
        }
        
        protected override function commitProperties():void
        {
            super.commitProperties();
            
            if(sequenceFontChanged) {
                sequenceFontChanged = false;
                
                invalidateDisplayList();
                
                var newSequenceTextFormat:TextFormat = new TextFormat(_sequenceSymbolRenderer.textFormat.font, _sequenceFontSize, _sequenceFontColor);
                var newComplimentaryTextFormat:TextFormat = new TextFormat(_revComSymbolRenderer.textFormat.font, _sequenceFontSize, _revComSequenceFontColor);
                
                _sequenceSymbolRenderer.textFormat = newSequenceTextFormat;
                _revComSymbolRenderer.textFormat = newComplimentaryTextFormat;
                
                clearSequenceTextRenderers();
                
                needsMeasurement = true;
            }
        }
        
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(needsMeasurement) {
				needsMeasurement = false;
				
				render();
			}
		}
		
		// Private Methods
		private function onRollOver(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.IBEAM;
			
			stage.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
        private function initializeProperties():void
        {
            sequenceFontColor = contentHolder.sequenceFontColor;
            revComSequenceFontColor = contentHolder.revComSequenceFontColor;
            sequenceFontSize = contentHolder.sequenceFontSize;
        }
        
        private function createSymbolRenderers():void
        {
            var widthGap:int = 0;
            var heighGap:int = 0;
            var fontSize:int = 11;
            var fontFace:String = "Monospace";
            var fontColor:int = 0x000000;
            
            if(SystemUtils.isLinuxOS()) {
                widthGap = 2;
                heighGap = 5;
                fontSize = 11;
                fontFace = SystemUtils.getSystemMonospaceFontFamily();
            } else if(SystemUtils.isWindowsOS()) {
                widthGap = 2;
                heighGap = 3;
                fontSize = 12;
                fontFace = SystemUtils.getSystemMonospaceFontFamily();
            } else if(SystemUtils.isMacOS()) {
                widthGap = 2;
                heighGap = 3;
                fontSize = 12;
                fontFace = SystemUtils.getSystemMonospaceFontFamily();
            }
            
            _sequenceSymbolRenderer = new SymbolRenderer(new TextFormat(fontFace, fontSize, _sequenceFontColor), widthGap, heighGap);
            _sequenceSymbolRenderer.includeInLayout = false;
            _sequenceSymbolRenderer.visible = false;
            
            _revComSymbolRenderer = new SymbolRenderer(new TextFormat(fontFace, fontSize, _revComSequenceFontColor), widthGap, heighGap);
            _revComSymbolRenderer.includeInLayout = false;
            _revComSymbolRenderer.visible = false;
            
            addChild(_sequenceSymbolRenderer);
            addChild(_revComSymbolRenderer);
            
            // Load dummy renderers to calculate width and height
            _sequenceSymbolRenderer.textToBitmap("A");
            _revComSymbolRenderer.textToBitmap("A");
        }
        
        private function clearSequenceTextRenderers():void
        {
            _sequenceSymbolRenderer.clearCache();
            _revComSymbolRenderer.clearCache();
            
            // Load dummy renderers to calculate width and height
            _sequenceSymbolRenderer.textToBitmap("A");
            _revComSymbolRenderer.textToBitmap("A");
        }
        
		private function render():void
		{
			var g:Graphics = graphics;
			g.clear();
			
            _totalWidth = 0;
			_totalHeight = 0;
			
			if(! contentHolder.sequenceProvider) { return; }
			
			var rows:Array = contentHolder.rowMapper.rows as Array /* of Row */;
			
			var sequenceNucleotideMatrix:Matrix = new Matrix();
			for(var i:int = 0; i < rows.length; i++) {
				var row:Row = rows[i] as Row;
				
				var rowX:Number = 0;
				var rowY:Number = _totalHeight;
				
				var sequenceString:String = "";
                if(contentHolder.showLineNumbers) {
				    sequenceString += renderIndexString(row.start + 1) + " ";	// Rendering index first
                } else {
                    sequenceString += " ";
                }
				
				if(contentHolder.showSpaceEvery10Bp) {
					sequenceString += splitWithSpaces(row.sequence); // Rendering sequence itself with spaces every 10bp
				} else {
					sequenceString += row.sequence; // Rendering sequence without spaces every 10bp
				}
				
				var sequenceStringLength:int = sequenceString.length;
				
				var sequenceX:Number = contentHolder.showLineNumbers ? 6 * _sequenceSymbolRenderer.textWidth : _sequenceSymbolRenderer.textWidth;
				var sequenceY:Number = _totalHeight;
				
				// Sequence
				for(var j:int = 0; j < sequenceStringLength; j++) {
					var nucleotideSymbolBitmap:BitmapData = _sequenceSymbolRenderer.textToBitmap(sequenceString.charAt(j));
					
					var nucleotidesLeftShift:int = j * nucleotideSymbolBitmap.width;
					sequenceNucleotideMatrix.tx += nucleotidesLeftShift;
					sequenceNucleotideMatrix.ty += _totalHeight;
					
					g.beginBitmapFill(nucleotideSymbolBitmap, sequenceNucleotideMatrix, false);
					g.drawRect(nucleotidesLeftShift, _totalHeight, nucleotideSymbolBitmap.width, nucleotideSymbolBitmap.height);
					g.endFill();
					
					sequenceNucleotideMatrix.tx -= nucleotidesLeftShift;
					sequenceNucleotideMatrix.ty -= _totalHeight;
				}
				
				if(_totalWidth < _sequenceSymbolRenderer.textWidth * sequenceStringLength) {
					_totalWidth = _sequenceSymbolRenderer.textWidth * sequenceStringLength;
				}
				_totalHeight += _sequenceSymbolRenderer.textHeight;
				
				var sequenceWidth:Number = sequenceStringLength * _sequenceSymbolRenderer.textWidth - sequenceX;
				var sequenceHeight:Number = _totalHeight - sequenceY;
				
				// Complementary Sequence
				if(contentHolder.showRevComplement) {
					renderComplementarySequence(row);
					
					sequenceHeight = _totalHeight - sequenceY;
				}
				
				_totalHeight += 3; // to look pretty
				
				var rowWidth:Number = _totalWidth;
				var rowHeight:Number = _totalHeight - rowY;
				
				row.metrics = new Rectangle(rowX, rowY, rowWidth, rowHeight);
				row.sequenceMetrics = new Rectangle(sequenceX, sequenceY, sequenceWidth, sequenceHeight);
			}
		}
		
		private function renderComplementarySequence(row:Row):void
		{
			var sequenceString:String = "";
            
            if(contentHolder.showLineNumbers) {
                sequenceString = "      ";
            } else {
                sequenceString = " ";
            }
			
			if(contentHolder.showSpaceEvery10Bp) {
				sequenceString += splitWithSpaces(row.revComSequence);
			} else {
				sequenceString += row.revComSequence;
			}
			
			var stringLength:int = sequenceString.length;
			var nucleotideMatrix:Matrix = new Matrix();
			
			var g:Graphics = graphics;
			
			for(var i:int = 0; i < stringLength; i++) {
				var complimentarySymbolBitmap:BitmapData = _revComSymbolRenderer.textToBitmap(sequenceString.charAt(i));
				
				var leftShift:int = i * complimentarySymbolBitmap.width;
				
				nucleotideMatrix.tx += leftShift;
				nucleotideMatrix.ty += _totalHeight;
				
				g.beginBitmapFill(complimentarySymbolBitmap, nucleotideMatrix, false);
				g.drawRect(leftShift, _totalHeight, complimentarySymbolBitmap.width, complimentarySymbolBitmap.height);
				g.endFill();
				
				nucleotideMatrix.tx -= leftShift;
				nucleotideMatrix.ty -= _totalHeight;
			}
			
			_totalHeight += _revComSymbolRenderer.textHeight;
		}
		
		private function renderIndexString(index:int):String
		{
			var result:String = String(index);
			
			if(index < 10) {
				result = "    " + result;
			} else if(index < 100) {
				result = "   " + result;
			} else if(index < 1000) {
				result = "  " + result;
			} else if(index < 10000) {
				result = " " + result;
			}
			
			return result;
		}
		
		private function splitWithSpaces(string:String, shift:int = 0, splitLast:Boolean = true):String
		{
			var result:String = "";
			
			var stringLength:int = string.length;
			
			if(stringLength <= 10 - shift) {
				result += string;
			} else {
				var start:int = 0;
				var end:int = 10 - shift;
				while(start < stringLength) {
					result += string.substring(start, end);
					
					start = end;
					end += 10;
					
					if(end <= contentHolder.bpPerRow) {
						result += " ";
					}
				}
			}
			
			return result;
		}
	}
}
