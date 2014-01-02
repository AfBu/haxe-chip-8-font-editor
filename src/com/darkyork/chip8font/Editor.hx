package com.darkyork.chip8font;

import com.darkyork.chip8font.ui.Button;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.ByteArray;
import openfl.Assets;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

/**
 * ...
 * @author Petr Kratina
 */
class Editor extends Sprite
{

	var btnBg:Sprite;
	var loadBtn:Button;
	var saveBtn:Button;
	var grid:Grid;
	var last:Int = 0;
	
	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	public function loadFont()
	{
		grid.fontset = Assets.getBytes("data/FONTSET");
		grid.fontset.position = grid.fontset.length;
		
		while (grid.fontset.length < 512)
		{
			grid.fontset.writeByte(0x00);
		}
		
		switchGrid(last, last >= 16 * 5);
	}
	
	public function saveFont()
	{
		var f:FileOutput = File.write(Assets.getPath("data/FONTSET"), true);
		f.writeBytes(grid.fontset, 0, 16 * 5 + 16 * 10);
		f.close();
	}
	
	public function init(e:Event)
	{
		removeEventListener(e.type, init);

		btnBg = new Sprite();
		addChild(btnBg);
		
		for (i in 0...16) {
			var b:Button = new Button(StringTools.hex(i), 1, 1 + i * 19, 20, 18, i);
			b.addEventListener(MouseEvent.CLICK, switchLetter);
			btnBg.addChild(b);
		}
		for (i in 0...16) {
			var b:Button = new Button(StringTools.hex(i), 22, 1 + i * 19, 20, 18, i);
			b.addEventListener(MouseEvent.CLICK, switchSuperLetter);
			btnBg.addChild(b);
		}
		
		loadBtn = new Button("load", 1, 0, 41);
		loadBtn.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) { loadFont(); } );
		btnBg.addChild(loadBtn);
		saveBtn = new Button("save", 1, 0, 41);
		saveBtn.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) { saveFont(); } );
		btnBg.addChild(saveBtn);
		
		redrawBtnBg();
		
		grid = new Grid();
		grid.x = 44;
		grid.y = 1;
		addChild(grid);
		
		loadFont();
		
		stage.addEventListener(Event.RESIZE, resize);
	}
	
	public function redrawBtnBg()
	{
		btnBg.graphics.clear();
		btnBg.graphics.beginFill(0x222222);
		btnBg.graphics.drawRect(0, 0, 43, stage.stageHeight);
		btnBg.graphics.endFill();
		
		saveBtn.y = stage.stageHeight - 19;
		loadBtn.y = stage.stageHeight - 19 - 20;
	}
	
	public function resize(e:Event)
	{
		redrawBtnBg();
	}
	
	public function switchLetter(e:MouseEvent)
	{
		var b:Button = e.currentTarget;
		var i:Int = b.data;
		
		switchGrid(i * 5);
	}
	
	public function switchSuperLetter(e:MouseEvent)
	{
		var b:Button = e.currentTarget;
		var i:Int = b.data;
		
		switchGrid(i * 10 + 16 * 5, true);
	}
	
	public function switchGrid(i:Int, s:Bool = false)
	{
		grid.load(i, s);
		last = i;
	}
	
}