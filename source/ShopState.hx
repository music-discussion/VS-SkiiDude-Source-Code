package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import lime.app.Application;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;
import openfl.Assets;
import io.newgrounds.NG;
import flixel.system.scaleModes.FixedScaleAdjustSizeScaleMode;
import cpp.abi.Abi;
import lime.system.DisplayMode;
import openfl.display.FPS;
import openfl.Lib;

// code stolen from my friend who made vs cutie
// much love thanks

using StringTools;

#if windows
import Discord.DiscordClient;
#end

class ShopState extends MusicBeatState
{
	var movedBack:Bool = false;
	
	var curSelected:Int = 0;
	
	var bg:FlxBackdrop;
	var sideleft:FlxBackdrop;
	var sideright:FlxBackdrop;
	
	var itemtext:FlxText;
	var itemtextd:FlxText;
	var itemtextp:FlxText;
	var priceText:FlxText;

	// ITEM BOUGHT DETECTION SHIT

	var ShopItem1bought:Bool = false;
	var ShopItem2bought:Bool = false;
	var ShopItem3bought:Bool = false;

	var OnShopItem1:Bool = false;
	var OnShopItem2:Bool = false;
	var OnShopItem3:Bool = false;

	// THATS IT CAUSE IM LAZY

	var coinImage:FlxSprite;
	var arrows:FlxSprite;

	var price:Float = 0;

	
	var shopItems:Array<String> = [
		'shop item 1',
		'shop item 2',
		'shop item 3'
	];
	
	var shopDesc:Array<String> = [
		'shop description 1',
		'shop description 2',
		'shop description 3'
	];

	var prices:Array<String> = [
		'100 Coins',
		'400 Coins',
		'700 Coins'
	];
	
	override function create()
	{	
		bg = new FlxBackdrop(Paths.image('shopBG'), 1, 1, true, true);
		bg.updateHitbox();
		bg.antialiasing = false;
		add(bg);
		
		sideleft = new FlxBackdrop(Paths.image('shopSideL'), 0, 1, false, true);
		sideleft.updateHitbox();
		sideleft.x = -128;
		sideleft.antialiasing = false;
		add(sideleft);
		
		sideright = new FlxBackdrop(Paths.image('shopSideR'), 0, 1, false, true);
		sideright.updateHitbox();
		sideright.x = 1280;
		sideright.antialiasing = false;
		add(sideright);
		
		itemtext = new FlxText(500, 500, 0, "Shop Item 1", 24);
		itemtext.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, RIGHT);
		itemtext.screenCenter();
		itemtext.y += 300;
		add(itemtext);
		
		itemtextd = new FlxText(500, 550, 0, "Shop Item 1", 24);
		itemtextd.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, RIGHT);
		itemtextd.screenCenter();
		itemtextd.y -= 250;
		itemtextd.x -= 125;
		add(itemtextd);

		itemtextp = new FlxText(500, 550, 0, "Shop Item 1", 24);
		itemtextp.setFormat("VCR OSD Mono", 24, FlxColor.YELLOW, RIGHT);
		itemtextp.screenCenter();
		itemtextp.y -= 300;
		add(itemtextp);

		priceText = new FlxText(500, 550, 0, "Coins", 24);
		priceText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, RIGHT);
		priceText.screenCenter();
		priceText.y += 250;
		priceText.x -= 50;
		add(priceText);

		priceText.text = "You have " + FlxG.save.data.coins + " Coins";

		// ALL THE IMAGE SPRITES FOR THE SHOP

		arrows = new FlxSprite(-450, 300).loadGraphic(Paths.image('shop/item1','shared'));
		arrows.antialiasing = true;
		arrows.screenCenter();
		arrows.scale.set(0.75, 0.75);
	//	add(coinImage);
		
		FlxTween.tween(sideleft, { x:0, y: 0 }, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(sideright, { x:1152, y: 0 }, 0.5, {ease: FlxEase.quadOut});
		
		super.create(); //how did i not know this makes the fade in appear? im a dumbass
		

	}
	
	override function update(elapsed:Float)
	{
		bg.x -= elapsed * 20;
		bg.y -= elapsed * 20;
		
		sideleft.y += elapsed * 20;
		sideright.y -= elapsed * 20;
		
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			
			FlxTween.tween(sideleft, { x:-128, y: 0 }, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(sideright, { x:1280, y: 0 }, 0.5, {ease: FlxEase.quadOut});
			
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}
		
		if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeitemselect(1);
			}
			
		if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeitemselect(-1);
			}
		if (controls.ACCEPT)
			{
				buy();
			}

		/*if (OnShopItem1 = true)
		{
			itemtextd.x = -15;
		}
		else if (OnShopItem2 = true)
		{
			itemtextd.x = 0;
		}
		else if (OnShopItem3 = true)
		{
			itemtextd.x = 0;
		}
		else
			trace('what the fuck, what kind of wizardry r you doing');*/
	}
	
	function changeitemselect(bruh:Int = 0)
	{
		curSelected += bruh;
		
			if (curSelected >= shopItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = shopItems.length - 1;
		
		//var itemchoice:Int = shopItems[curSelected];

		switch (shopItems[curSelected])
		{
			case 'shop item 1':
				itemtext.text = "Custom Snow Notes";
				OnShopItem1 = true;
				OnShopItem2 = false;
				OnShopItem3 = false;
				add(arrows);
			case 'shop item 2':
				itemtext.text = "Shop Item 2";
				OnShopItem1 = false;
				OnShopItem2 = true;
				OnShopItem3 = false;
				remove(arrows);
			case 'shop item 3':
				itemtext.text = "Shop Item 3";
				OnShopItem1 = false;
				OnShopItem2 = false;
				OnShopItem3 = true;
				remove(arrows);
		}

		switch (shopDesc[curSelected])
		{
			case 'shop description 1':
				itemtextd.text = "Buy Custom Snow notes for VS Skii Dude. NOTE: Not Reversible.";
			case 'shop description 2':
				itemtextd.text = "Shop Desc 2";
			case 'shop description 3':
				itemtextd.text = "Shop Desc 3";
		}

		switch (prices[curSelected])
		{
			case '100 Coins':
				itemtextp.text = "2000 Coins to buy this item.";
				price = 2000;
			case '400 Coins':
				itemtextp.text = "9999999999 Coins to buy this";
				price = 9999999999;
			case '700 Coins':
				itemtextp.text = "9999999999 Coins to buy this";
				price = 9999999999;
		}
	}

	function updateDisplay():String
		{
			return FlxG.save.data.coins + (FlxG.save.data.coins);
		}

	function buy() // this code i actually made lol, sorry in advance if its a bit messy but it gets the job done
	{
			switch (prices[curSelected])
			{
				case '100 Coins':
					price = 2000;
				case '9999999999 Coins to buy this':
					price = 9999999999;
				case '9999999999 Coins to buy this':
					price = 9999999999;
			}

			if (FlxG.save.data.coins >= price)
			{
				if (price == 100 && OnShopItem1 == true && !FlxG.save.data.shopItem1)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					ShopItem1bought = true;
					FlxG.save.data.shopItem = true;
					trace(ShopItem1bought);
					FlxG.save.data.coins -= 100;
					updateDisplay();
				//	return true;
					FlxG.save.flush();
					trace('100 coin shit bought');
				}
				else if (price == 400 && OnShopItem2 == true && !FlxG.save.data.shopItem2)
					{
						FlxG.sound.play(Paths.sound('confirmMenu'));
						ShopItem2bought = true;
						FlxG.save.data.shopItem2 = true;
						FlxG.save.data.coins -= 400;
						updateDisplay();
						trace(ShopItem2bought);
		//				return true;
						FlxG.save.flush();
						trace('400 coin shit bought');
					}
				else if (price == 700 && OnShopItem3 == true && !FlxG.save.data.shopItem3)
					{
						FlxG.sound.play(Paths.sound('confirmMenu'));
						ShopItem3bought = true;
						FlxG.save.data.shopItem = true;
						trace(ShopItem3bought);
						FlxG.save.data.coins -= 700;
						updateDisplay();
					//	return true;
						FlxG.save.flush();
						trace('700 coin shit bought');
					}
			}
			else
			{
				trace('you cant buy anything shit');
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			}
	}

}