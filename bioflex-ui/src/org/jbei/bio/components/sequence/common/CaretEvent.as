package org.jbei.bio.components.sequence.common
{
    import flash.events.Event;

    /**
     * @author Zinovii Dmytriv
     */
    public class CaretEvent extends Event
    {
        public var position:int = -1;
        
        // Static Constants
        public static const CARET_POSITION_CHANGED:String = "CaretPositionChanged";
        
        // Constructor
        public function CaretEvent(type:String, position:int)
        {
            this.position = position;
            
            super(type, true, true);
        }
    }
}