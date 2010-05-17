package org.jbei.bio.components.sequence.sequenceEditorClasses
{
    import flash.ui.ContextMenuItem;
    
    import mx.core.UIComponent;
    
    import org.jbei.bio.components.sequence.SequenceProvider;
    import org.jbei.bio.components.sequence.SequenceProviderEvent;
    import org.jbei.bio.components.sequence.common.DataProvider;
    import org.jbei.bio.components.sequence.common.IRenderer;
    import org.jbei.bio.sequence.dna.DNASequence;
    
    /**
     * @author Zinovii Dmytriv
     */
    public class AnnotationRenderer implements IRenderer
    {
        protected var _dataProvider:DataProvider;
        
        protected var contextMenuItems:Vector.<ContextMenuItem> = new Vector.<ContextMenuItem>();
        
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
        public function getContextMenuItems(target:AnnotationItem = null):Vector.<ContextMenuItem>
        {
            contextMenuItems.splice(0, contextMenuItems.length);
            
            registerContextMenuItems(target);
            
            return contextMenuItems;
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
