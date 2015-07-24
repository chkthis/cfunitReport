package net.sourceforge.cfunitReport.models {

	[Bindable]
	public class Test {
			
	    public var id:String;
	    public var threadid:String;
	    public var application:String;
	    public var status:Number;
	    public var counters:String;
	    public var date:String;
	    public var time:String;
	    public var message:String;
	    
	    public function Test() { }
	
	    public function fill(obj:Object):void {
	        for (var i:String in obj) {
	            this[i] = obj[i];
	        }
	    }
	
	   public function toString():String {
	   		return id+' {'+message+'}';
	   }
	   
	}

}