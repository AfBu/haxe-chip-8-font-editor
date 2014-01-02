package com.darkyork.chip8font.ui;

import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

/**
 * ...
 * @author Petr Kratina
 */
class Button extends Sprite
{

	public var w:Float = 100;
	public var h:Float = 20;
	public var text:TextField;
	public var data:Int = 0;
	
	public function new(text:String = "Button", x:Float = 0, y:Float = 0, width:Float = 100, height:Float = 18, data:Int = 0 ) 
	{
		super();
	
		this.data = data;
		
		this.text = new TextField();
		this.text.text = text;
		
		this.x = x;
		this.y = y;
		this.w = width;
		this.h = height;
		
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	public function redraw(down:Bool = false, hover:Bool = false)
	{
		var c1:Int = 0xCCCCCC;
		var c2:Int = 0x666666;
		
		if (hover) {
			c1 = 0xEEEEEE;
			c2 = 0xAAAAAA;
		}
		if (down) {
			c2 = 0xEEEEEE;
			c1 = 0xAAAAAA;
		}
		
		//graphics.lineStyle(1, 0xFFFFFF);
		var m:Matrix = new Matrix();
		m.createGradientBox(w, h, Math.PI / 2, 0, 0);
		graphics.beginGradientFill(GradientType.LINEAR, [c1, c2], [1, 1], [0, 255], m, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB, 0);
		graphics.drawRect(0, 0, w, h);
		graphics.endFill();
	}
	
	public function init(e:Event)
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		addEventListener(MouseEvent.MOUSE_OVER, function (e:MouseEvent) { redraw(false, true); } );
		addEventListener(MouseEvent.MOUSE_OUT, function (e:MouseEvent) { redraw(false, false); } );
		addEventListener(MouseEvent.MOUSE_DOWN, function (e:MouseEvent) { redraw(true, true); } );
		addEventListener(MouseEvent.MOUSE_UP, function (e:MouseEvent) { redraw(false, true); } );
		
		text.width = w;
		text.height = h;
		text.setTextFormat(new TextFormat("", 10, 0x000000, true, false, false, null, null, TextFormatAlign.CENTER));
		text.selectable = false;
		addChild(text);
		
		redraw();
	}
	
}