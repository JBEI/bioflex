package org.jbei.bio.components.sequence
{
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    
    import mx.core.ScrollControlBase;
    import mx.core.ScrollPolicy;
    import mx.events.ResizeEvent;
    import mx.events.ScrollEvent;
    import mx.events.ScrollEventDirection;
    import mx.managers.IFocusManagerComponent;
    
    import org.jbei.bio.components.sequence.SequenceProvider;
    import org.jbei.bio.components.sequence.common.IRenderer;
    import org.jbei.bio.components.sequence.common.PrintableContent;
    import org.jbei.bio.components.sequence.sequenceEditorClasses.ContentHolder;

    [Event(name="selectionChanged", type="org.jbei.bio.components.sequence.common.SelectionEvent")]
    [Event(name="caretPositionChanged", type="org.jbei.bio.components.sequence.common.CaretEvent")]
    
    /**
     * @author Zinovii Dmytriv
     */
    public class SequenceEditor extends ScrollControlBase implements IFocusManagerComponent
    {
        public static const DEFAULT_BP_PER_ROW:int = 60;
        public static const MIN_BP_PER_ROW:int = 10;
        public static const MAX_BP_PER_ROW:int = 200;
        
        public static const DEFAULT_SEQUENCE_FONT_SIZE:int = 11;
        public static const MIN_SEQUENCE_FONT_SIZE:int = 10;
        public static const MAX_SEQUENCE_FONT_SIZE:int = 18;
        
        public static const DEFAULT_SEQUENCE_FONT_COLOR:int = 0x000000;
        public static const DEFAULT_REVCOM_SEQUENCE_FONT_COLOR:int = 0xB0B0B0;
        public static const DEFAULT_SHOW_REV_COMPLEMENT:Boolean = true;
        public static const DEFAULT_SHOW_SPACE_EVERY_10_BP:Boolean = true;
        public static const DEFAULT_FLOATING_WIDTH:Boolean = false;
        public static const DEFAULT_READ_ONLY:Boolean = false;
        public static const DEFAULT_SHOW_HORIZONTAL_LINES:Boolean = true;
        public static const DEFAULT_SHOW_LINE_NUMBERS:Boolean = true;
        
        private var contentHolder:ContentHolder;
        
        private var _sequenceProvider:SequenceProvider;
        
        private var _bpPerRow:int = DEFAULT_BP_PER_ROW;
        private var _sequenceFontSize:int = DEFAULT_SEQUENCE_FONT_SIZE;
        private var _sequenceFontColor:int = DEFAULT_SEQUENCE_FONT_COLOR;
        private var _revComSequenceFontColor:int = DEFAULT_REVCOM_SEQUENCE_FONT_COLOR;
        private var _floatingWidth:Boolean = DEFAULT_FLOATING_WIDTH;
        private var _showRevComplement:Boolean = DEFAULT_SHOW_REV_COMPLEMENT;
        private var _showSpaceEvery10Bp:Boolean = DEFAULT_SHOW_SPACE_EVERY_10_BP;
        private var _readOnly:Boolean = DEFAULT_READ_ONLY;
        private var _showHorizontalLines:Boolean = DEFAULT_SHOW_HORIZONTAL_LINES;
        private var _showLineNumbers:Boolean = DEFAULT_SHOW_LINE_NUMBERS;
        
        private var bpPerRowChanged:Boolean = false;
        private var sequenceFontChanged:Boolean = false;
        private var needsMeasurement:Boolean = false;
        private var sequenceFontColorChanged:Boolean = false;
        private var floatingWidthChanged:Boolean = false;
        private var showRevComplementChanged:Boolean = false;
        private var showSpaceEvery10BpChanged:Boolean = false;
        private var readOnlyChanged:Boolean = false;
        private var showHorizontalLinesChanged:Boolean = false;
        private var showLineNumbersChanged:Boolean = false;
        private var sequenceProviderChanged:Boolean = false;
        
        // Constructor
        public function SequenceEditor()
        {
            super();
            
            verticalScrollPolicy = ScrollPolicy.AUTO;
            horizontalScrollPolicy = ScrollPolicy.AUTO;
            
            liveScrolling = true;
            
            addEventListener(ScrollEvent.SCROLL, onScroll);
            addEventListener(ResizeEvent.RESIZE, onResize);
            addEventListener(MouseEvent.CLICK, onMouseClick);
            addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
            addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
        }
        
        // Properties
        public function get bpPerRow():int
        {
            return _bpPerRow;
        }
        
        public function set bpPerRow(value:int):void
        {
            _bpPerRow = value;
            
            if(_bpPerRow % 10 != 0) {
                _bpPerRow = int(_bpPerRow / 10);
            }
            
            if(_bpPerRow < MIN_BP_PER_ROW) {
                _bpPerRow = MIN_BP_PER_ROW;
            } else if(_bpPerRow > MAX_BP_PER_ROW) {
                _bpPerRow = MAX_BP_PER_ROW;
            }
            
            bpPerRowChanged = true;
            
            invalidateProperties();
        }
        
        public function get sequenceProvider():SequenceProvider
        {
            return _sequenceProvider;
        }
        
        public function set sequenceProvider(value:SequenceProvider):void
        {
            _sequenceProvider = value;
            
            sequenceProviderChanged = true;
            
            invalidateProperties();
        }
        
        public function get floatingWidth():Boolean
        {
            return _floatingWidth;
        }
        
        public function set floatingWidth(value:Boolean):void
        {
            _floatingWidth = value;
            
            floatingWidthChanged = true;
            
            invalidateProperties();
        }
        
        public function get revComSequenceFontColor():int
        {
            return _revComSequenceFontColor;
        }
        
        public function set revComSequenceFontColor(value:int):void
        {
            _revComSequenceFontColor = value;
            
            sequenceFontColorChanged = true;
            
            invalidateProperties();
        }
        
        public function get sequenceFontColor():int
        {
            return _sequenceFontColor;
        }
        
        public function set sequenceFontColor(value:int):void
        {
            _sequenceFontColor = value;
            
            sequenceFontColorChanged = true;
            
            invalidateProperties();
        }
        
        public function get sequenceFontSize():int
        {
            return _sequenceFontSize;
        }
        
        public function set sequenceFontSize(value:int):void
        {
            _sequenceFontSize = value;
            
            if(_sequenceFontSize < MIN_SEQUENCE_FONT_SIZE) {
                _sequenceFontSize = MIN_SEQUENCE_FONT_SIZE;
            } else if(_sequenceFontSize > MAX_SEQUENCE_FONT_SIZE) {
                _sequenceFontSize = MAX_SEQUENCE_FONT_SIZE;
            }
            
            sequenceFontChanged = true;
            
            invalidateProperties();
        }
        
        public function get showRevComplement():Boolean
        {
            return _showRevComplement;
        }
        
        public function set showRevComplement(value:Boolean):void
        {
            _showRevComplement = value;
            
            showRevComplementChanged = true;
            
            invalidateProperties();
        }
        
        public function get showSpaceEvery10Bp():Boolean
        {
            return _showSpaceEvery10Bp;
        }
        
        public function set showSpaceEvery10Bp(value:Boolean):void
        {
            _showSpaceEvery10Bp = value;
            
            showSpaceEvery10BpChanged = true;
            
            invalidateProperties();
        }
        
        public function get showHorizontalLines():Boolean
        {
            return _showHorizontalLines;
        }
        
        public function set showHorizontalLines(value:Boolean):void
        {
            _showHorizontalLines = value;
            
            showHorizontalLinesChanged = true;
            
            invalidateProperties();
        }
        
        public function get showLineNumbers():Boolean
        {
            return _showLineNumbers;
        }
        
        public function set showLineNumbers(value:Boolean):void
        {
            _showLineNumbers = value;
            
            showLineNumbersChanged = true;
            
            invalidateProperties();
        }
        
        public function get readOnly():Boolean
        {
            return _readOnly;
        }
        
        public function set readOnly(value:Boolean):void
        {
            _readOnly = value;
            
            readOnlyChanged = true;
            
            invalidateProperties();
        }
        
        public function get caretPosition():int
        {
            return contentHolder.caretPosition;
        }
        
        public function set caretPosition(value:int):void
        {
            contentHolder.caretPosition = value;
        }
        
        public function get selectionStart():int
        {
            return contentHolder.selectionStart;
        }
        
        public function get selectionEnd():int
        {
            return contentHolder.selectionEnd;
        }
        
        public final function get renderers():Vector.<IRenderer>
        {
            return contentHolder.getRenderers();
        }
        
        // Public Methods
        public function select(start:int, end:int):void
        {
            contentHolder.select(start, end);
        }
        
        public function deselect():void
        {
            contentHolder.deselect();
        }
        
        public function printingContent(pageWidth:Number, pageHeight:Number):PrintableContent
        {
            var printableContent:PrintableContent = new PrintableContent();
            
            printableContent.width = contentHolder.totalWidth;
            printableContent.height = contentHolder.totalHeight;
            
            var numPages:int = Math.ceil(contentHolder.totalHeight / pageHeight);
            
            for(var i:int = 0; i < numPages; i++) {
                printableContent.pages.push(contentHolder.contentBitmapData(i, pageWidth, pageHeight));
            }
            
            return printableContent;
        }
        
        public function registerRenderer(name:String, renderer:IRenderer):void
        {
            contentHolder.registerRenderer(name, renderer);
        }
        
        public function unregisterRenderer(renderer:IRenderer):void
        {
            contentHolder.unregisterRenderer(renderer);
        }
        
        public function getRenderer(name:String):IRenderer
        {
            return contentHolder.getRenderer(name);
        }
        
        // Protected Methods
        protected override function createChildren():void
        {
            super.createChildren();
            
            createContentHolder();
        }
        
        protected override function commitProperties():void
        {
            super.commitProperties();
            
            if(sequenceProviderChanged) {
                sequenceProviderChanged = false;
                
                verticalScrollPosition = 0;
                horizontalScrollPosition = 0;
                
                contentHolder.x = 0;
                contentHolder.y = 0;
                
                contentHolder.sequenceProvider = _sequenceProvider;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(bpPerRowChanged && _bpPerRow != contentHolder.bpPerRow) {
                bpPerRowChanged = false;
                
                contentHolder.bpPerRow = _bpPerRow;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(sequenceFontChanged && _sequenceFontSize != contentHolder.sequenceFontSize) {
                sequenceFontChanged = false;
                
                contentHolder.sequenceFontSize = _sequenceFontSize;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(sequenceFontColorChanged && (_sequenceFontColor != contentHolder.sequenceFontColor || _revComSequenceFontColor != contentHolder.revComSequenceFontColor)) {
                sequenceFontColorChanged = false;
                
                contentHolder.sequenceFontColor = _sequenceFontColor;
                contentHolder.revComSequenceFontColor = _revComSequenceFontColor;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(floatingWidthChanged && _floatingWidth != contentHolder.floatingWidth) {
                floatingWidthChanged = false;
                
                contentHolder.floatingWidth = _floatingWidth;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(showRevComplementChanged && _showRevComplement != contentHolder.showRevComplement) {
                showRevComplementChanged = false;
                
                contentHolder.showRevComplement = _showRevComplement;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(showSpaceEvery10BpChanged && _showSpaceEvery10Bp != contentHolder.showSpaceEvery10Bp) {
                showSpaceEvery10BpChanged = false;
                
                contentHolder.showSpaceEvery10Bp = _showSpaceEvery10Bp;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(readOnlyChanged && _readOnly != contentHolder.readOnly) {
                readOnlyChanged = false;
                
                contentHolder.readOnly = _readOnly;
            }
            
            if(showLineNumbersChanged && _showLineNumbers != contentHolder.showLineNumbers) {
                showLineNumbersChanged = false;
                
                contentHolder.showLineNumbers = _showLineNumbers;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(showHorizontalLinesChanged && _showHorizontalLines != contentHolder.showHorizontalLines) {
                showHorizontalLinesChanged = false;
                
                contentHolder.showHorizontalLines = _showHorizontalLines;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
        }
        
        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if(needsMeasurement) {
                needsMeasurement = false;
                
                //dispatchEvent(new UpdateEvent(UpdateEvent.BEFORE_UPDATE));
                
                try {
                    contentHolder.updateMetrics(unscaledWidth, unscaledHeight);
                    contentHolder.validateNow();
                    
                    adjustScrollBars();
                } catch (error:Error) {
                    trace(error.getStackTrace());
                } finally {
                    //dispatchEvent(new UpdateEvent(UpdateEvent.AFTER_UPDATE));
                }
            }
        }
        
        protected override function mouseWheelHandler(event:MouseEvent):void
        {
            if(verticalScrollBar) {
                doScroll(event.delta, verticalScrollBar.lineScrollSize);
            }
        }
        
        // Event Handlers
        private function onScroll(event:ScrollEvent):void
        {
            if(event.direction == ScrollEventDirection.HORIZONTAL) {
                // Adjust content position. Content moves into oposide direction to scroll.
                contentHolder.x = -event.position;
                
                // Adjust scroll position to content position
                if (horizontalScrollPosition != -contentHolder.x) {
                    horizontalScrollPosition = -contentHolder.x;
                }
            } else if(event.direction == ScrollEventDirection.VERTICAL) {
                // Adjust content position. Content moves into oposide direction to scroll.
                contentHolder.y = -event.position;
                
                // Prevent scrolling further then content
                if(contentHolder.y + contentHolder.totalHeight < height) {
                    contentHolder.y += height - (contentHolder.y + contentHolder.totalHeight)
                }
                
                // Adjust scroll position to content position
                if (verticalScrollPosition != -contentHolder.y) {
                    verticalScrollPosition = -contentHolder.y;
                }
            }
        }
        
        private function onResize(event:ResizeEvent):void
        {
            horizontalScrollPosition = 0;
            verticalScrollPosition = 0;
            
            if(contentHolder) {
                contentHolder.y = 0;
                contentHolder.x = 0;
            }
            
            needsMeasurement = true;
            
            invalidateDisplayList();
        }
        
        private function onFocusIn(event:FocusEvent):void
        {
            contentHolder.focusIn();
        }
        
        private function onFocusOut(event:FocusEvent):void
        {
            contentHolder.focusOut();
        }
        
        private function onMouseClick(event:MouseEvent):void
        {
            if(focusManager.getFocus() != this) {
                focusManager.setFocus(this);
            }
        }
        
        // Private Methods
        private function createContentHolder():void
        {
            if(!contentHolder) {
                contentHolder = new ContentHolder(this);
                contentHolder.includeInLayout = false;
                addChild(contentHolder);
                // Make content fit into ScrollControlBase control
                // Hide invisible portion of the content
                contentHolder.mask = maskShape;
            }
        }
        
        private function adjustScrollBars():void
        {
            setScrollBarProperties(contentHolder.totalWidth, width, contentHolder.totalHeight, height);
            
            if(verticalScrollBar) {
                verticalScrollBar.lineScrollSize = contentHolder.averageRowHeight;
                verticalScrollBar.pageScrollSize = verticalScrollBar.lineScrollSize * 10;
            }
        }
        
        private function doScroll(delta:int, speed:uint = 3):void
        {
            if (verticalScrollBar && verticalScrollBar.visible) {
                var scrollDirection:int = delta <= 0 ? 1 : -1;
                
                var oldPosition:Number = verticalScrollPosition;
                verticalScrollPosition += speed * scrollDirection;
                
                if(verticalScrollPosition < 0) {
                    verticalScrollPosition = 0;
                }
                
                var scrollEvent:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
                scrollEvent.direction = ScrollEventDirection.VERTICAL;
                scrollEvent.position = verticalScrollPosition;
                scrollEvent.delta = verticalScrollPosition - oldPosition;
                dispatchEvent(scrollEvent);
            }
        }
     }
}