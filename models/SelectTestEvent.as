package net.sourceforge.cfunitReport.models {
	
    import flash.events.Event;
    import mx.controls.Alert;

    public class SelectTestEvent extends Event {
    	public static const SELECTED:String = "testSelected";
		public var id:String;
		
        public function SelectTestEvent(i:String) {
        	super( SELECTED );
        	this.id = i;
        }
        
        override public function clone():Event {
        	return new SelectTestEvent( this.id );
      	}
    }
}