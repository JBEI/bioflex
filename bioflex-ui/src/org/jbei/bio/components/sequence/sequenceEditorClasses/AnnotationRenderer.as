package org.jbei.bio.components.sequence.sequenceEditorClasses
{
    import flash.geom.Point;
    import flash.ui.ContextMenuItem;
    
    import org.jbei.bio.components.sequence.common.DataProvider;
    import org.jbei.bio.components.sequence.common.IRenderer;
    
    /**
     * @author Zinovii Dmytriv
     */
    public class AnnotationRenderer implements IRenderer
    {
        protected var _dataProvider:DataProvider;
        
        protected var contextMenuItems:Vector.<ContextMenuItem> = new Vector.<ContextMenuItem>();
        protected var bpPerRow:int;
        protected var showLineNumbers:Boolean;
        protected var showSpaceEvery10Bp:Boolean;
        protected var symbolWidth:int;
        protected var rowRenderingPoints:Vector.<Point>;
        
        // Constructor
        public function AnnotationRenderer(dataProvider:DataProvider)
        {
            _dataProvider = dataProvider;
        }
        
        // Properties
        public function get dataProvider():DataProvider
        {
            return _dataProvider;
        }
        
        // Public Methods
        public function setRenderingPoint(rowIndex:int, x:Number, y:Number):void
        {
            rowRenderingPoints[rowIndex] = new Point(x, y);
        }
        
        public function getContextMenuItems(target:AnnotationItem = null):Vector.<ContextMenuItem>
        {
            contextMenuItems.splice(0, contextMenuItems.length);
            
            registerContextMenuItems(target);
            
            return contextMenuItems;
        }
        
        public function update(bpPerRow:int, showLineNumbers:Boolean, showSpaceEvery10Bp:Boolean, symbolWidth:int):void
        {
            this.bpPerRow = bpPerRow;
            this.showLineNumbers = showLineNumbers;
            this.showSpaceEvery10Bp = showSpaceEvery10Bp;
            this.symbolWidth = symbolWidth;
            
            rowRenderingPoints = new Vector.<Point>(getNumberOfRows(), true);
        }
        
        public function getRowHeight(rowIndex:int):Number
        {
            return 0;
        }
        
        // Protected Methods
        protected function getNumberOfRows():int
        {
            return int(Math.ceil((dataProvider.sequenceProvider.length / bpPerRow)));
        }
        
        // Protected Methods
        protected function registerContextMenuItems(target:AnnotationItem):void
        {
            
        }
        
        protected function handleClick(target:AnnotationItem):void
        {
            
        }
        
        protected function handleDoubleClick(target:AnnotationItem):void
        {
            
        }
    }
}
