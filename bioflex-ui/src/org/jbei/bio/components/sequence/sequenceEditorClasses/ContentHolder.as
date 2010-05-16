package org.jbei.bio.components.sequence.sequenceEditorClasses
{
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    
    import org.jbei.bio.components.sequence.SequenceEditor;
    import org.jbei.bio.components.sequence.SequenceProvider;
    import org.jbei.bio.components.sequence.common.CaretEvent;
    import org.jbei.bio.components.sequence.common.IRenderer;
    import org.jbei.bio.components.sequence.common.SelectionEvent;

    /**
     * @author Zinovii Dmytriv
     */
    public class ContentHolder extends UIComponent
    {
        public static const BACKGROUND_COLOR:int = 0xFFFFFF;
        public static const SPLIT_LINE_COLOR:int = 0x000000;
        public static const SPLIT_LINE_TRANSPARENCY:Number = 0.15;
        public static const FEATURED_SEQUENCE_CLIPBOARD_KEY:String = "FeaturedSequenceObject";
        
        private var sequenceEditor:SequenceEditor;
        private var renderers:Vector.<IRenderer> = new Vector.<IRenderer>();
        private var renderersByName:Dictionary = new Dictionary() /* of [name] = IRenderer */;
        private var caret:Caret;
        private var selectionLayer:SelectionLayer;
        private var sequenceRenderer:SequenceRenderer;
        private var customContextMenu:ContextMenu;
        private var editFeatureContextMenuItem:ContextMenuItem;
        private var removeFeatureContextMenuItem:ContextMenuItem;
        private var selectedAsNewFeatureContextMenuItem:ContextMenuItem;
        
        private var _sequenceProvider:SequenceProvider;
        
        private var _bpPerRow:int;
        private var _floatingWidth:Boolean;
        private var _readOnly:Boolean = false;
        private var _revComSequenceFontColor:int;
        private var _sequenceFontColor:int;
        private var _sequenceFontSize:int;
        private var _showRevComplement:Boolean;
        private var _showSpaceEvery10Bp:Boolean;
        private var _showHorizontalLines:Boolean;
        private var _showLineNumbers:Boolean;
        private var _caretPosition:int = 0;
        private var _selectionStart:int = 0;
        private var _selectionEnd:int = 0;
        private var _totalHeight:int = 0;
        private var _totalWidth:int = 0;
        private var _averageRowHeight:int = 0;
        private var _rowMapper:RowMapper;
        
        private var bpPerRowChanged:Boolean = false;
        private var floatingWidthChanged:Boolean = false;
        private var sequenceFontChanged:Boolean = false;
        private var showRevComplementChanged:Boolean = false;
        private var showSpaceEvery10BpChanged:Boolean = false;
        private var showHorizontalLinesChanged:Boolean = false;
        private var showLineNumbersChanged:Boolean = false;
        private var sequenceProviderChanged:Boolean = false;
        private var rowMapperChanged:Boolean = false;
        
        private var invalidSequence:Boolean = true;
        private var startHandleResizing:Boolean = false;
        private var endHandleResizing:Boolean = false;
        private var mouseIsDown:Boolean = false;
        private var selectionDirection:int = 0;
        private var parentWidth:Number = 0;
        private var parentHeight:Number = 0;
        private var shiftDownCaretPosition:int = -1;
        private var needsMeasurement:Boolean = false;
        private var shiftKeyDown:Boolean = false;
        private var keysSelectionDirection:int = 0;
        
        // Constructor
        public function ContentHolder(sequenceEditor:SequenceEditor)
        {
            super();
            
            this.sequenceEditor = sequenceEditor;
            
            doubleClickEnabled = true;
            
            _rowMapper = new RowMapper(this);
            
            initializeProperties();
        }
        
        // Properties
        public function get averageRowHeight():int
        {
            return _averageRowHeight;
        }
        
        public function get bpPerRow():int
        {
            return _bpPerRow;
        }
        
        public function set bpPerRow(value:int):void
        {
            _bpPerRow = value;
            
            bpPerRowChanged = true;
            
            invalidateProperties();
        }
        
        public function get caretPosition():int
        {
            return _caretPosition;
        }
        
        public function set caretPosition(value:int):void
        {
            if (value != caretPosition) {
                tryMoveCaretToPosition(value);
            }
        }
        
        public function get sequenceProvider():SequenceProvider
        {
            return _sequenceProvider;
        }
        
        public function set sequenceProvider(value:SequenceProvider):void
        {
            _sequenceProvider = value;
            
            invalidateProperties();
            
            sequenceProviderChanged = true;
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
        
        public function get readOnly():Boolean
        {
            return _readOnly;
        }
        
        public function set readOnly(value:Boolean):void
        {
            _readOnly = value;
        }
        
        public function get revComSequenceFontColor():int
        {
            return _revComSequenceFontColor;
        }
        
        public function set revComSequenceFontColor(value:int):void
        {
            _revComSequenceFontColor = value;
            
            sequenceFontChanged = true;
            
            invalidateProperties();
        }
        
        public function get rowMapper():RowMapper
        {
            return _rowMapper;
        }
        
        public function get sequenceFontColor():int
        {
            return _sequenceFontColor;
        }
        
        public function set sequenceFontColor(value:int):void
        {
            _sequenceFontColor = value;
            
            sequenceFontChanged = true;
            
            invalidateProperties();
        }
        
        public function get sequenceFontSize():int
        {
            return _sequenceFontSize;
        }
        
        public function set sequenceFontSize(value:int):void
        {
            _sequenceFontSize = value;
            
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
        
        public function get selectionStart():int
        {
            return _selectionStart;
        }
        
        public function get selectionEnd():int
        {
            return _selectionEnd;
        }
        
        public function get totalHeight():int
        {
            return _totalHeight;
        }
        
        public function get totalWidth():int
        {
            return _totalWidth;
        }
        
        // Public Methods
        public function select(startIndex: int, endIndex: int):void
        {
            if(invalidSequence) { return; }
            
            if(!isValidIndex(startIndex) || !isValidIndex(endIndex)) {
                deselect();
                
                return;
            }
            
            if((selectionLayer.start != startIndex || selectionLayer.end != endIndex) && startIndex != endIndex) {
                doSelect(startIndex, endIndex);
                
                dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, startIndex, endIndex));
                
                tryMoveCaretToPosition(endIndex);
            }
        }
        
        public function deselect():void
        {
            if(invalidSequence) { return; }
            
            if(selectionLayer.selected) {
                doDeselect();
                
                dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, selectionLayer.start, selectionLayer.end));
            }
        }
        
        public function updateMetrics(parentWidth:Number, parentHeight:Number):void
        {
            this.parentWidth = parentWidth;
            this.parentHeight = parentHeight;
            
            if(_floatingWidth) {
                invalidateProperties();
                
                floatingWidthChanged = true;
            }
            
            needsMeasurement = true;
            
            invalidateDisplayList();
        }
        
        public function contentBitmapData(page:int, pageWidth:Number, pageHeight:Number):BitmapData
        {
            var currentHeight:Number = Math.min(pageHeight, totalHeight - pageHeight * page);
            
            var bitmapData:BitmapData = new BitmapData(pageWidth, currentHeight);
            var matrix:Matrix = new Matrix(1, 0, 0, 1, 0, -pageHeight * page);
            bitmapData.draw(this, matrix, null, null, new Rectangle(0, 0, pageWidth, currentHeight));
            
            return bitmapData;
        }
        
        public function bpMetricsByIndex(index:int):Rectangle
        {
            if(!isValidIndex(index)) {
                throw new Error("Can't get bp metrics for bp with index " + String(index));
            }
            
            var row:Row = rowByBpIndex(index);
            
            var resultMetrics:Rectangle;
            
            if(row == null) {
                throw new Error("Can't get bp point for index: " + String(index));  // => this case should never happen
            } else {
                var numberOfCharacters:int = index - row.index * _bpPerRow;
                
                if(_showSpaceEvery10Bp) {
                    numberOfCharacters += int(numberOfCharacters / 10);
                }
                
                var bpX:Number = row.sequenceMetrics.x + numberOfCharacters * sequenceRenderer.sequenceSymbolRenderer.textWidth;
                var bpY:Number = row.sequenceMetrics.y;
                
                resultMetrics = new Rectangle(bpX, bpY, sequenceRenderer.sequenceSymbolRenderer.textWidth, sequenceRenderer.sequenceSymbolRenderer.textHeight);
            }
            
            return resultMetrics;
        }
        
        public function rowByBpIndex(index:int):Row
        {
            if(!isValidIndex(index)) {
                throw new Error("Can't get row for bp with index " + String(index));
            }
            
            return _rowMapper.rows[int(Math.floor(index / _bpPerRow))];
        }
        
        public function getRenderers():Vector.<IRenderer>
        {
            return renderers;
        }
        
        public function registerRenderer(name:String, renderer:IRenderer):void
        {
            if(renderersByName[name] != null) {
                throw new Error("Failed to register renderer! Name should be unique.");
            }
            
            renderers.push(renderer);
            renderersByName[name] = renderer;
        }
        
        public function unregisterRenderer(renderer:IRenderer):void
        {
            var index:int = renderers.indexOf(renderer);
            
            if(index == -1) {
                throw new Error("Failed to unregister not registered renderer!");
            }
            
            renderers.splice(index, 1);
            
            for(var name:String in renderersByName) {
                if(renderer == renderersByName[name]) {
                    renderersByName[name] = null;
                    
                    break;
                }
            }
        }
        
        public function getRenderer(name:String):IRenderer
        {
            return renderersByName[name];
        }
        
        public function focusIn():void
        {
            caret.show();
        }
        
        public function focusOut():void
        {
            caret.hide();
        }
        
        // Protected Methods
        protected override function createChildren():void
        {
            super.createChildren();
            
            createContextMenu();
            
            createSequenceRenderer();
            
            createCaret();
            
            createSelectionLayer();
        }
        
        protected override function commitProperties():void
        {
            super.commitProperties();
            
            if(! _sequenceProvider) {
                disableSequence();
                
                invalidateDisplayList();
                
                return;
            }
            
            if(sequenceProviderChanged) {
                sequenceProviderChanged = false;
                
                rowMapperChanged = true;
                needsMeasurement = true;
                
                initializeSequence();
                
                invalidateDisplayList();
            }
            
            if(showRevComplementChanged) {
                showRevComplementChanged = false;
                
                needsMeasurement = true;
                rowMapperChanged = true;
                
                invalidateDisplayList();
            }
            
            if(bpPerRowChanged) {
                bpPerRowChanged = false;
                
                needsMeasurement = true;
                rowMapperChanged = true;
                
                invalidateDisplayList();
            }
            
            if(sequenceFontChanged) {
                sequenceFontChanged = false;
                
                needsMeasurement = true;
                
                sequenceRenderer.sequenceFontSize = _sequenceFontSize;
                sequenceRenderer.sequenceFontColor = _sequenceFontColor;
                sequenceRenderer.revComSequenceFontColor = _revComSequenceFontColor;
                
                invalidateDisplayList();
            }
            
            if(showSpaceEvery10BpChanged) {
                showSpaceEvery10BpChanged = false;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(floatingWidthChanged) {
                floatingWidthChanged = false;
                
                needsMeasurement = true;
                rowMapperChanged = true;
                
                invalidateDisplayList();
                
                updateFloatingBpPerRow();
            }
            
            if(showLineNumbersChanged) {
                showLineNumbersChanged = false;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
            
            if(showHorizontalLinesChanged) {
                showHorizontalLinesChanged = false;
                
                needsMeasurement = true;
                
                invalidateDisplayList();
            }
        }
        
        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if(invalidSequence) {
                _totalHeight = parentHeight;
                _totalWidth = parentWidth;
                
                drawBackground();
                
                doDeselect();
                caret.hide();
                
                sequenceRenderer.update();
                sequenceRenderer.validateNow();
                
                return;
            }
            
            if(rowMapperChanged) {
                rowMapperChanged = false;
                
                rowMapper.update();
                doDeselect();
            }
            
            if(needsMeasurement) {
                needsMeasurement = false;
                
                sequenceRenderer.update();
                sequenceRenderer.validateNow();
                
                adjustCaretSize();
                
                _totalHeight = Math.max(sequenceRenderer.totalHeight + 20, parentHeight); // +20 for scrollbar
                _totalWidth = Math.max(sequenceRenderer.totalWidth + 20, parentWidth);    // +20 for scrollbar
                
                drawBackground();
                
                if(_showHorizontalLines) {
                    drawSplitLines();
                }
                
                updateAverageRowHeight();
                
                if(isValidIndex(_selectionStart) && isValidIndex(_selectionEnd)) {
                    doSelect(_selectionStart, _selectionEnd);
                    
                    if(numChildren > 1) {
                        swapChildren(selectionLayer, getChildAt(numChildren - 1));
                    }
                }
            }
            
            tryMoveCaretToPosition(_caretPosition);
        }
        
        // Event Handlers
        private function onMouseDown(event:MouseEvent):void
        {
            //if(event.target is AnnotationRenderer) { return; }
            
            if(selectionLayer.selected) { deselect(); }
            
            mouseIsDown = true;
            
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            
            if(!startHandleResizing && !endHandleResizing) {
                _selectionStart = bpAtPoint(new Point(event.localX, event.localY));
            
                selectionDirection = 0;
            }
            
            tryMoveCaretToPosition(_selectionStart);
        }
        
        private function onMouseMove(event:MouseEvent):void
        {
            if(mouseIsDown || startHandleResizing || endHandleResizing) {
                var bpIndex:int = bpAtPoint(new Point(mouseX, mouseY));
                
                if(bpIndex == -1) { return; }
                
                if(startHandleResizing) {
                    _selectionStart = bpIndex;
                    
                    selectionDirection = 1; // ignore direction on resizing
                    
                    tryMoveCaretToPosition(_selectionStart);
                } else if(endHandleResizing) {
                    _selectionEnd = bpIndex;
                    
                    selectionDirection = 1; // ignore direction on resizing
                    
                    tryMoveCaretToPosition(_selectionEnd);
                } else {
                    _selectionEnd = bpIndex;
                    
                    tryMoveCaretToPosition(_selectionEnd);
                }
                
                if(isValidIndex(_selectionStart) && isValidIndex(_selectionEnd)) {
                    if(selectionDirection == 0 && _selectionStart != _selectionEnd) {
                        selectionDirection = (_selectionStart < _selectionEnd) ? 1 : -1;
                    }
                    
                    var start:int = (selectionDirection == -1) ? _selectionEnd : _selectionStart;
                    var end:int = (selectionDirection == -1) ? _selectionStart : _selectionEnd;
                    
                    selectionLayer.startSelecting();
                    selectionLayer.select(start, end);
                }
            }
        }
        
        private function onMouseUp(event:MouseEvent):void
        {
            if(!(mouseIsDown || startHandleResizing || endHandleResizing)) { return; }
            
            mouseIsDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            
            if(selectionLayer.selected && selectionLayer.selecting) {
                selectionLayer.endSelecting();
                
                dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, selectionLayer.start, selectionLayer.end));
            }
        }
        
        private function onSelectionHandleClicked(event:SelectionLayerEvent):void
        {
            _selectionStart = selectionLayer.start;
            _selectionEnd = selectionLayer.end;
            
            startHandleResizing = event.handleKind == SelectionHandle.START_HANDLE;
            endHandleResizing = event.handleKind == SelectionHandle.END_HANDLE;
            
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        
        private function onSelectionHandleReleased(event:SelectionLayerEvent):void
        {
            startHandleResizing = false;
            endHandleResizing = false;
            
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        
        private function onSelectAll(event:Event):void
        {
            select(0, _sequenceProvider.length);
        }
        
        private function onCopy(event:Event):void
        {
            if(isValidIndex(selectionLayer.start) && isValidIndex(selectionLayer.end)) {
                Clipboard.generalClipboard.clear();
                //Clipboard.generalClipboard.setData(FEATURED_SEQUENCE_CLIPBOARD_KEY, _featuredSequence.subFeaturedSequence(selectionLayer.start, selectionLayer.end), true);
                //Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _featuredSequence.subSequence(selectionLayer.start, selectionLayer.end).sequence, true);
            }
        }
        
        private function onCut(event:Event):void
        {
            if(isValidIndex(selectionLayer.start) && isValidIndex(selectionLayer.end)) {
                Clipboard.generalClipboard.clear();
                //Clipboard.generalClipboard.setData(FEATURED_SEQUENCE_CLIPBOARD_KEY, _featuredSequence.subFeaturedSequence(selectionLayer.start, selectionLayer.end), true);
                //Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _featuredSequence.subSequence(selectionLayer.start, selectionLayer.end).sequence, true);
                
                /*if(_safeEditing) {
                    doDeleteSequence(selectionLayer.start, selectionLayer.end);
                } else {
                    _featuredSequence.removeSequence(selectionLayer.start, selectionLayer.end);
                    
                    deselect();
                }*/
            }
        }
        
        private function onPaste(event:Event):void
        {
            if(! isValidIndex(_caretPosition)) { return; }
            
            if(Clipboard.generalClipboard.hasFormat(FEATURED_SEQUENCE_CLIPBOARD_KEY)) {
                var clipboardObject:Object = Clipboard.generalClipboard.getData(FEATURED_SEQUENCE_CLIPBOARD_KEY);
                
                if(clipboardObject != null) {
                    /*var pasteFeaturedSequence:FeaturedSequence = clipboardObject as FeaturedSequence;
                    var pasteSequence1:String = pasteFeaturedSequence.sequence.seqString();
                    
                    if(!SequenceUtils.isCompatibleSequence(pasteSequence1)) {
                        showInvalidPasteSequenceAlert();
                        
                        return;
                    } else {
                        pasteSequence1 = SequenceUtils.purifyCompatibleSequence(pasteSequence1);
                    }
                    
                    if(_safeEditing) {
                        doInsertFeaturedSequence(pasteFeaturedSequence, _caretPosition);
                    } else {
                        _featuredSequence.insertFeaturedSequence(pasteFeaturedSequence, _caretPosition);
                        
                        tryMoveCaretToPosition(_caretPosition + pasteSequence1.length);
                    }*/
                }
            } else if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) {
                /*var pasteSequence2:String = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT, ClipboardTransferMode.CLONE_ONLY)).toUpperCase();
                
                if(!SequenceUtils.isCompatibleSequence(pasteSequence2)) {
                    showInvalidPasteSequenceAlert();
                    
                    return;
                } else {
                    pasteSequence2 = SequenceUtils.purifyCompatibleSequence(pasteSequence2);
                }
                
                if(_safeEditing) {
                    doInsertSequence(new DNASequence(pasteSequence2), _caretPosition);
                } else {
                    _featuredSequence.insertSequence(new DNASequence(pasteSequence2), _caretPosition);
                    
                    tryMoveCaretToPosition(_caretPosition + pasteSequence2.length);
                }*/
            }
        }
        
        private function onKeyUp(event:KeyboardEvent):void
        {
            if(!event.shiftKey) {
                shiftKeyDown = false;
            }
        }
        
        private function onKeyDown(event:KeyboardEvent):void
        {
            var keyCharacter:String = String.fromCharCode(event.charCode).toUpperCase();
            
            if(event.shiftKey && !shiftKeyDown) {
                shiftDownCaretPosition = _caretPosition;
                shiftKeyDown = true;
                keysSelectionDirection = 0;
            }
            
            if(event.ctrlKey && event.keyCode == Keyboard.LEFT) {
                tryMoveCaretToPosition((_caretPosition % 10 == 0) ? _caretPosition - 10 : int(_caretPosition / 10) * 10);
            } else if(event.ctrlKey && event.keyCode == Keyboard.RIGHT) {
                tryMoveCaretToPosition((_caretPosition % 10 == 0) ? _caretPosition + 10 : int(_caretPosition / 10 + 1) * 10);
            } else if(event.ctrlKey && event.keyCode == Keyboard.HOME) {
                tryMoveCaretToPosition(0);
            } else if(event.ctrlKey && event.keyCode == Keyboard.END) {
                tryMoveCaretToPosition(_sequenceProvider.length);
            } else if(event.keyCode == Keyboard.LEFT) {
                tryMoveCaretToPosition(_caretPosition - 1);
            } else if(event.keyCode == Keyboard.UP) {
                tryMoveCaretToPosition(_caretPosition - bpPerRow);
            } else if(event.keyCode == Keyboard.RIGHT) {
                tryMoveCaretToPosition(_caretPosition + 1);
            } else if(event.keyCode == Keyboard.DOWN) {
                tryMoveCaretToPosition(_caretPosition + bpPerRow);
            } else if(event.keyCode == Keyboard.HOME || event.keyCode == Keyboard.END) {
                var row:Row = rowByBpIndex(_caretPosition);
                
                if(event.keyCode == Keyboard.HOME) {
                    tryMoveCaretToPosition(row.start);
                } else {
                    tryMoveCaretToPosition(row.end);
                }
            } else if(event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN) {
                var numberOfVisibleRows:int = Math.max(int(sequenceEditor.height / _averageRowHeight - 1), 1);
                
                if(event.keyCode == Keyboard.PAGE_UP) {
                    tryMoveCaretToPosition(_caretPosition - numberOfVisibleRows * _bpPerRow);
                } else {
                    tryMoveCaretToPosition(_caretPosition + numberOfVisibleRows * _bpPerRow);
                }
            } else if(!event.ctrlKey && !event.altKey && _caretPosition != -1) {
                /*if(SequenceUtils.SYMBOLS.indexOf(keyCharacter) >= 0) {
                    if(_safeEditing) {
                        doInsertSequence(new DNASequence(keyCharacter), _caretPosition);
                    } else {
                        _featuredSequence.insertSequence(new DNASequence(keyCharacter), _caretPosition);
                        
                        tryMoveCaretToPosition(_caretPosition + 1);
                    }
                } else if(event.keyCode == Keyboard.DELETE) {
                    if(selectionLayer.selected) {
                        if(_safeEditing) {
                            doDeleteSequence(selectionLayer.start, selectionLayer.end);
                        } else {
                            _featuredSequence.removeSequence(selectionLayer.start, selectionLayer.end);
                            
                            tryMoveCaretToPosition(selectionLayer.start);
                            
                            deselect();
                        }
                    } else {
                        if(_safeEditing) {
                            doDeleteSequence(_caretPosition, _caretPosition + 1);
                        } else {
                            _featuredSequence.removeSequence(_caretPosition, _caretPosition + 1);
                        }
                    }
                } else if(event.keyCode == Keyboard.BACKSPACE && _caretPosition > 0) {
                    if(selectionLayer.selected) {
                        if(_safeEditing) {
                            doDeleteSequence(selectionLayer.start, selectionLayer.end);
                        } else {
                            _featuredSequence.removeSequence(selectionLayer.start, selectionLayer.end);
                            
                            tryMoveCaretToPosition(selectionLayer.start);
                            
                            deselect();
                        }
                    } else {
                        if(_safeEditing) {
                            doDeleteSequence(_caretPosition - 1, _caretPosition);
                        } else {
                            _featuredSequence.removeSequence(_caretPosition - 1, _caretPosition);
                            
                            tryMoveCaretToPosition(_caretPosition - 1);
                        }
                    }
                }*/
            }
            
            if(shiftKeyDown) {
                if(keysSelectionDirection == 0) {
                    if(_caretPosition > shiftDownCaretPosition) {
                        keysSelectionDirection = 1;
                    } else if(_caretPosition < shiftDownCaretPosition) {
                        keysSelectionDirection = -1;
                    } else {
                        deselect();
                        return;
                    }
                }
                
                if(isValidIndex(shiftDownCaretPosition) && isValidIndex(_caretPosition)) {
                    if(keysSelectionDirection == 1) {
                        doSelect(shiftDownCaretPosition, _caretPosition);
                        
                        dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, shiftDownCaretPosition, _caretPosition));
                    } else {
                        doSelect(_caretPosition, shiftDownCaretPosition);
                        
                        dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, _caretPosition, shiftDownCaretPosition));
                    }
                }
            }
        }
        
        private function onSelectionChanged(event:SelectionEvent):void
        {
            if(event.start >= 0 && event.end >= 0) {
                customContextMenu.clipboardItems.copy = true;
                customContextMenu.clipboardItems.cut = _readOnly ? false : true;
            } else {
                customContextMenu.clipboardItems.copy = false;
                customContextMenu.clipboardItems.cut = false;
            }
        }
        
        private function onEditFeatureMenuItem(event:ContextMenuEvent):void
        {
            /*if(event.mouseTarget is FeatureRenderer) {
                dispatchEvent(new CommonEvent(CommonEvent.EDIT_FEATURE, true, true, (event.mouseTarget as FeatureRenderer).feature));
            }*/
        }
        
        private function onRemoveFeatureMenuItem(event:ContextMenuEvent):void
        {
            /*if(event.mouseTarget is FeatureRenderer) {
                dispatchEvent(new CommonEvent(CommonEvent.REMOVE_FEATURE, true, true, (event.mouseTarget as FeatureRenderer).feature));
            }*/
        }
        
        private function onSelectedAsNewFeatureMenuItem(event:ContextMenuEvent):void
        {
            //dispatchEvent(new CommonEvent(CommonEvent.CREATE_FEATURE, true, true, new Feature(selectionLayer.start, selectionLayer.end)));
        }
        
        private function onContextMenuSelect(event:ContextMenuEvent):void
        {
            customContextMenu.customItems = new Array();
            
            /*if(event.mouseTarget is FeatureRenderer) {
                customContextMenu.customItems.push(editFeatureContextMenuItem);
                customContextMenu.customItems.push(removeFeatureContextMenuItem);
            }*/
            
            if(selectionLayer.selected) {
                customContextMenu.customItems.push(selectedAsNewFeatureContextMenuItem);
            }
        }
        
        // Private Methods
        private function initializeProperties():void
        {
            _bpPerRow = sequenceEditor.bpPerRow;
            _floatingWidth = sequenceEditor.floatingWidth;
            _sequenceFontColor = sequenceEditor.sequenceFontColor;
            _sequenceFontSize = sequenceEditor.sequenceFontSize;
            _revComSequenceFontColor = sequenceEditor.revComSequenceFontColor;
            _showSpaceEvery10Bp = sequenceEditor.showSpaceEvery10Bp;
            _showRevComplement = sequenceEditor.showRevComplement;
            _readOnly = sequenceEditor.readOnly;
            _showLineNumbers = sequenceEditor.showLineNumbers;
            _showHorizontalLines = sequenceEditor.showHorizontalLines;
        }
        
        private function createCaret():void
        {
            if(!caret) {
                caret = new Caret(this);
                caret.includeInLayout = false;
                caret.hide();
                addChild(caret);
                
                // set caret height according to default sequence height
                caret.caretHeight = _showRevComplement ? 2 * sequenceRenderer.sequenceSymbolRenderer.textHeight : sequenceRenderer.sequenceSymbolRenderer.textHeight;
            }
        }
        
        private function createSequenceRenderer():void
        {
            if(sequenceRenderer == null) {
                sequenceRenderer = new SequenceRenderer(this);
                
                addChild(sequenceRenderer);
            }
        }
        
        private function createContextMenu():void
        {
            customContextMenu = new ContextMenu();
            
            customContextMenu.hideBuiltInItems(); //hide the Flash built-in menu
            customContextMenu.clipboardMenu = true; // activate Copy, Paste, Cut, Menu items
            customContextMenu.clipboardItems.paste = _readOnly ? false : true;
            customContextMenu.clipboardItems.selectAll = true;
            
            contextMenu = customContextMenu;
            
            customContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, onContextMenuSelect);
            
            if(! _readOnly) {
                createCustomContextMenuItems();
            }
        }
        
        private function createCustomContextMenuItems():void
        {
            editFeatureContextMenuItem = new ContextMenuItem("Edit Feature");
            editFeatureContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onEditFeatureMenuItem);
            
            removeFeatureContextMenuItem = new ContextMenuItem("Remove Feature");
            removeFeatureContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onRemoveFeatureMenuItem);
            
            selectedAsNewFeatureContextMenuItem = new ContextMenuItem("Selected as New Feature");
            selectedAsNewFeatureContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSelectedAsNewFeatureMenuItem);
        }
        
        private function createSelectionLayer():void
        {
            if(selectionLayer == null) {
                selectionLayer = new SelectionLayer(this);
                selectionLayer.includeInLayout = false;
                addChild(selectionLayer);
                
                if(numChildren > 1) {
                    swapChildren(selectionLayer, getChildAt(numChildren - 1));
                }
                
                selectionLayer.addEventListener(SelectionLayerEvent.SELECTION_HANDLE_CLICKED, onSelectionHandleClicked);
                selectionLayer.addEventListener(SelectionLayerEvent.SELECTION_HANDLE_RELEASED, onSelectionHandleReleased);
            }
        }
        
        private function disableSequence():void
        {
            invalidSequence = true;
            
            caretPosition = 0;
            
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            //removeEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClick);
            
            sequenceEditor.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            sequenceEditor.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            
            sequenceEditor.removeEventListener(Event.SELECT_ALL, onSelectAll);
            sequenceEditor.removeEventListener(Event.COPY, onCopy);
            if(!_readOnly) {
                sequenceEditor.removeEventListener(Event.CUT, onCut);
                sequenceEditor.removeEventListener(Event.PASTE, onPaste);
            }
            
            removeEventListener(SelectionEvent.SELECTION_CHANGED, onSelectionChanged);
            
            rowMapperChanged = true;
            needsMeasurement = true;
        }
        
        private function initializeSequence():void
        {
            invalidSequence = false;
            
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            //addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClick);
            
            sequenceEditor.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            sequenceEditor.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            
            sequenceEditor.addEventListener(Event.SELECT_ALL, onSelectAll);
            sequenceEditor.addEventListener(Event.COPY, onCopy);
            if(!_readOnly) {
                sequenceEditor.addEventListener(Event.CUT, onCut);
                sequenceEditor.addEventListener(Event.PASTE, onPaste);
            }
            
            addEventListener(SelectionEvent.SELECTION_CHANGED, onSelectionChanged);
            
            rowMapperChanged = true;
            needsMeasurement = true;
        }
        
        private function tryMoveCaretToPosition(newPosition:int):void
        {
            if(invalidSequence) { return; }
            
            if(newPosition < 0) {
                newPosition = 0;
            } else if(newPosition > _sequenceProvider.length) {
                newPosition = _sequenceProvider.length;
            }
            
            moveCaretToPosition(newPosition);
        }
        
        private function moveCaretToPosition(newPosition:int):void
        {
            if(! isValidIndex(newPosition)) {
                throw new Error("Invalid caret position: " + String(newPosition));
            }
            
            if(newPosition != _caretPosition) {
                _caretPosition = newPosition;
                
                dispatchEvent(new CaretEvent(CaretEvent.CARET_POSITION_CHANGED, _caretPosition));
            }
            
            caret.position = _caretPosition;
            
            adjustContentToCaret();
        }
        
        private function adjustContentToCaret():void
        {
            var row:Row = rowByBpIndex(_caretPosition);
            
            if(!row) { return; }
            
            if(_totalHeight < sequenceEditor.verticalScrollPosition + sequenceEditor.height) {
                this.y = sequenceEditor.height - _totalHeight;
                sequenceEditor.verticalScrollPosition = -this.y;
            }
            
            if(row.metrics.y + row.metrics.height > sequenceEditor.verticalScrollPosition + sequenceEditor.height) {
                this.y = sequenceEditor.height - (row.metrics.y + row.metrics.height + 20); // +20 extra space for horizontal scroll bar
                if (sequenceEditor.verticalScrollPosition != -this.y) {
                    sequenceEditor.verticalScrollPosition = -this.y;
                }
            } else if(row.metrics.y < sequenceEditor.verticalScrollPosition) {
                this.y = -row.metrics.y;
                if (sequenceEditor.verticalScrollPosition != -this.y) {
                    sequenceEditor.verticalScrollPosition = -this.y;
                }
            }
            
            if (caret.x > sequenceEditor.horizontalScrollPosition + sequenceEditor.width - 20) { // -20 vertical scroll adjustment
                this.x = sequenceEditor.width - Math.min(caret.x + sequenceRenderer.sequenceSymbolRenderer.textWidth * 10, this.totalWidth) - 20; // shift to the right by 10bp width, -20 vertical scroll width adjustment 
                if (sequenceEditor.horizontalScrollPosition != -this.x) {
                    sequenceEditor.horizontalScrollPosition = -this.x;
                }
            } else if(caret.x < sequenceEditor.horizontalScrollPosition + 5) { // +5 to look pretty
                this.x = -Math.max(0, caret.x - sequenceRenderer.sequenceSymbolRenderer.textWidth * 10); // shift to the left by 10bp width 
                if (sequenceEditor.horizontalScrollPosition != -this.x) {
                    sequenceEditor.horizontalScrollPosition = -this.x;
                }
            }
        }
        
        private function adjustCaretSize():void
        {
            // set caret height according to default sequence height
            caret.caretHeight = _showRevComplement ? 2 * sequenceRenderer.sequenceSymbolRenderer.textHeight : sequenceRenderer.sequenceSymbolRenderer.textHeight;
        }
        
        public function isValidIndex(index:int):Boolean
        {
            return index >= 0 && index <= _sequenceProvider.length;
        }
        
        private function doSelect(startIndex:int, endIndex:int):void
        {
            if(startIndex > 0 && endIndex == 0) {
                endIndex == _sequenceProvider.length - 1;
            }
            
            selectionLayer.deselect();
            if(isValidIndex(startIndex) && isValidIndex(endIndex)) {
                selectionLayer.startSelecting();
                selectionLayer.select(startIndex, endIndex);
                selectionLayer.endSelecting();
            }
            
            _selectionStart = startIndex;
            _selectionEnd = endIndex;
        }
        
        private function doDeselect():void
        {
            _selectionStart = -1;
            _selectionEnd = -1;
            selectionLayer.deselect();
        }
        
        private function bpAtPoint(point:Point):int
        {
            var numberOfRows:int = rowMapper.rows.length;
            
            var bpIndex:int = -1;
            for(var i:int = 0; i < numberOfRows; i++) {
                var row:Row = rowMapper.rows[i] as Row;
                
                if((point.y >= row.metrics.y) && (point.y <= row.metrics.y + row.metrics.height)) {
                    bpIndex = i * _bpPerRow;
                    
                    if(point.x < row.sequenceMetrics.x) {
                    } else if(point.x > row.sequenceMetrics.x + row.sequenceMetrics.width) {
                        bpIndex += row.sequence.length;
                    } else {
                        var numberOfCharactersFromBegining:int = Math.floor((point.x - row.sequenceMetrics.x + (sequenceRenderer.sequenceSymbolRenderer.textWidth - 1) / 2) / sequenceRenderer.sequenceSymbolRenderer.textWidth);
                        
                        var numberOfSpaces:int = 0;
                        
                        if(_showSpaceEvery10Bp) {
                            numberOfSpaces = int(numberOfCharactersFromBegining / 11);
                        }
                        
                        var numberOfValidCharacters:int = numberOfCharactersFromBegining - numberOfSpaces;
                        
                        bpIndex += numberOfValidCharacters;
                    }
                    
                    break;
                }
            }
            
            return bpIndex;
        }
        
        private function updateFloatingBpPerRow():void
        {
            var numberOfFittingBP:int = int((sequenceEditor.width - 30) / sequenceRenderer.sequenceSymbolRenderer.textWidth) - 7; // -30 for scrollbar and extra space, -7 for index
            
            var extraSpaces:int = showSpaceEvery10Bp ? int(numberOfFittingBP / 10) : 0;
            
            _bpPerRow = (numberOfFittingBP < 20) ? 10 : (10 * int(Math.floor((numberOfFittingBP - extraSpaces) / 10)));
        }
        
        private function drawBackground():void
        {
            var g:Graphics = graphics;
            
            g.clear();
            g.beginFill(BACKGROUND_COLOR);
            g.drawRect(0, 0, _totalWidth, _totalHeight);
            g.endFill();
        }
        
        private function drawSplitLines():void
        {
            var g:Graphics = graphics;
            
            var numberOfRows:int = rowMapper.rows.length;
            for(var i:int = 0; i < numberOfRows; i++) {
                var row:Row = rowMapper.rows[i] as Row;
                
                if(i != numberOfRows - 1) {
                    g.lineStyle(1, SPLIT_LINE_COLOR, SPLIT_LINE_TRANSPARENCY);
                    g.moveTo(row.metrics.x, row.metrics.y + row.metrics.height - 1);
                    g.lineTo(_totalWidth, row.metrics.y + row.metrics.height - 1);
                }
            }
        }
        
        private function updateAverageRowHeight():void
        {
            var totalHeight:Number = 0;
            
            var numberOfRows:int = rowMapper.rows.length;
            for(var i:int = 0; i < numberOfRows; i++) {
                var row:Row = rowMapper.rows[i] as Row;
                
                totalHeight += row.metrics.height;
            }
            
            _averageRowHeight = (numberOfRows > 0) ? totalHeight / numberOfRows : 0;
        }
    }
}