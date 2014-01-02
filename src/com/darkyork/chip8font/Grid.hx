package com.darkyork.chip8font;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.ByteArray;

/**
 * ...
 * @author Petr Kratina
 */
class Grid extends Sprite
{
	var sx:Int = -1;
	var sy:Int = -1;	
	var d:Bool = false;
	var s:Bool = true;
	var zoom:Float = 16;
	var pixels:Array<Bool>;
	var w:Int = 8;
	var h:Int = 10;
	var ci:Int = 0;
	public var fontset:ByteArray;
	
	public function new() 
	{
		super();
		
		fontset = new ByteArray();
		
		pixels = new Array<Bool>();
		for (i in 0...8 * 10) pixels.push(false);
		
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	public function init(e:Event)
	{
		removeEventListener(e.type, init);
		
		redraw();
		
		addEventListener(MouseEvent.MOUSE_MOVE, function (e:MouseEvent) { mouseMove(e); } );
		addEventListener(MouseEvent.MOUSE_OUT, function (e:MouseEvent) { sx = -1; sy = -1; d = false; } );
		addEventListener(MouseEvent.MOUSE_DOWN, function (e:MouseEvent) { d = true; mouseMove(e, true); } );
		addEventListener(MouseEvent.MOUSE_UP, function (e:MouseEvent) { d = false; } );
	}
	
	public function mouseMove(e:MouseEvent, initial:Bool = false)
	{
		sx = Math.floor(e.localX / (zoom + 1));
		sy = Math.floor(e.localY / (zoom + 1));
		
		if (initial) s = !getPixel(sx, sy);
		
		if (d) {
			setPixel(sx, sy, false, s);
		}
		
		redraw();
	}
	
	public function redraw()
	{
		graphics.clear();
		graphics.beginFill(0x000000);
		graphics.drawRect(0, 0, (w + 1) * zoom, (h + 1) * zoom);
		graphics.endFill();
		
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var c:Int = 0x222222;
				if (sx == x && sy == y) {
					c = 0x444444;
					if (getPixel(x, y)) c = 0xFFFFFF;
				} else {
					if (getPixel(x, y)) c = 0xDDDDDD;
				}
				graphics.beginFill(c);
				graphics.drawRect(x * zoom + x, y * zoom + y, zoom, zoom);
				graphics.endFill();
			}
		}
	}
	
	public function getPixelIndex(x:Float, y:Float, mouse:Bool = false):Int
	{
		if (mouse) {
			x = Math.floor(x / (zoom + 1));
			y = Math.floor(y / (zoom + 1));
		}
		
		var px:Int = Math.round(x);
		var py:Int = Math.round(y);
		
		return (py * 16 + px);
	}
	
	public function getPixel(x:Float, y:Float, mouse:Bool = false):Bool
	{
		var i:Int = getPixelIndex(x, y, mouse);
		
		return pixels[i];
	}

	public function setPixel(x:Float, y:Float, mouse:Bool = false, state:Bool = true, doSave:Bool = true)
	{
		var i:Int = getPixelIndex(x, y, mouse);
		
		pixels[i] = state;
		
		if (doSave) save();
	}
	
	public function load(i:Int, superFont:Bool = false)
	{
		ci = i;
		w = 8;
		h = (superFont ? 10 : 5);
		var x:Int = 0;
		var y:Int = 0;
		for (l in i...i + h)
		{
			var b:Int = fontset[l];
			
			for (n in 0...8) 
			{
				setPixel(x, y, false, ((b & (1 << 7 - n)) == 0 ? false : true), false);
				x++;
			}
			x = 0;
			y++;
		}
		
		if (!superFont) 
		{
			w = 4;
		}
		
		redraw();
	}
	
	public function save()
	{
		for (y in 0...h) 
		{
			var b:Int = 0;
			var c:Int = 128;
			for (x in 0...(h == 10 ? 8 : 4)) {
				if (getPixel(x, y)) b += c;
				c = Math.round(c / 2);
			}
			fontset[ci + y] = b;
		}
	}

}