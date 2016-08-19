﻿/** Band.as** Simon Twigger, 2005* $id$*** Base actionscript class file for a genomic Band for the Flash GViewer***/class Band extends MovieClip {	public var bandIndex:Number;	public var bandName:String;	public var bandChr:String	public var start:Number;	public var end:Number;	public var stain:String;	public var bandColor:Number;		public var link:String; // not implemented yet	public var bandHolder:MovieClip;	public var tip:MovieClip;	public var regionHilite:MovieClip;	public var featureLabel:MovieClip;		public var featureBgColor:Number;	public var hiliteStayOn:Boolean = false;	public var bandWidth;	public var startX:Number;	public var startY:Number;			public function Band (index:Number,name:String, chr:String, startPos:Number, endPos:Number,stain:String,bColor:Number,linkUrl:String) {		this.bandIndex = index;		this.bandName = name;		this.bandChr = chr;		this.start = startPos;		this.end = endPos;		this.stain = stain;		this.bandColor = bColor;		this.link = linkUrl;			}		public static function createBand(		target:MovieClip,		depth:Number, 		x:Number,		y:Number,		index:Number,		name:String,		chr:String,		startPos:Number,		endPos:Number,		stain:String,		bColor:Number,		linkUrl:String		):Band {				// create a unique Band name from band, name and depth		var band_unique_name:Band = Band(target.attachMovie("BandSymbol", index + "_" + name + "_" + depth, depth));				band_unique_name.init(target, x, y, index, name, chr, startPos, endPos, stain, bColor, linkUrl);		//band_unique_name._alpha = defaultTransparency; // set to transparent				return band_unique_name;	}		public function init(target:MovieClip, x:Number, y:Number, index:Number, name:String, chr:String, startPos:Number, endPos:Number, stain:String, bColor:Number, linkUrl:String):Void {		this.bandHolder = target;		this.bandIndex = index;		this.bandName = name;		this.bandChr = chr;		this.start = startPos;		this.end = endPos;		this.stain = stain;		this.bandColor = bColor;		this.link = linkUrl;				this._x = x;		this._y = y;		this.startX = x;		this.startY = y;	}		/**	*	* draws the appropriate colored band, width and heigh provided by	* external object	*	*/		public function drawBand(bandWidth:Number,bandHeight:Number,newColor:Number):Void {				var newBandColor:Number = 0xFFFFFF; // default		this.bandWidth = bandWidth;		if(newColor) {			//this.beginFill(newColor, 100);			newBandColor = Number(newColor);		}		else if(this.bandColor) {								newBandColor = Number(this.bandColor);		}		else {			switch (this.stain) {			case "gpos" :			case "gpos100" :				newBandColor = Number(0x000000);				break;			case "gpos75" :				newBandColor = Number(0x444444);				break;			case "gpos66" :				newBandColor = Number(0x666666);				break;			case "gpos50" :				newBandColor = Number(0x888888);				break;			case "gpos33" :				newBandColor = Number(0xAAAAAA);				break;			case "gpos25" :				newBandColor = Number(0xCCCCCC);				break;			case "gneg" :				newBandColor = Number(0xFFFFFF);				break;			case "gvar" :				newBandColor = Number(0xCCCCCC);				break;			default :				newBandColor = Number(0xCCCCCC);				break;			}			this.bandColor = newBandColor;		}			// set up the linear gradient fill parameters		var matrix:Object = {matrixType:"box", x:0, y:0, w:bandWidth, h:bandHeight, r:0};		var colors =[0xFFFFFF,newBandColor,newBandColor,0x000000];		var alphas = [255,255,255,255];		var ratios = [0,75,175,255];				this.beginGradientFill("linear",colors,alphas,ratios,matrix);		this.moveTo(0,0);		this.lineTo(bandWidth,0);		this.lineTo(bandWidth,bandHeight);		this.lineTo(0,bandHeight);		this.lineTo(0,0);		this.endFill();				this.endFill();	}			public function onRollOver(){		_root.featureInfo.text = "Chr: " + this.bandChr + " (" + this.start + "-" + this.end + ") " + this.bandName;			/*		if(_parent._parent._alpha == 100) {			this.drawBand(this._width,this._height,0xFF0000);		}		*/		trace("looking for outlinks");		for (var f = 0; f< this._parent._parent.outLinkList.length; f++) {				var linkObject:Object = this._parent._parent.outLinkList[f];				// trace("outlist local object: " + linkObject.localFeature.label_internal);				 this._parent._parent.drawLinkLine(linkObject.localFeature, linkObject.remoteFeature, linkObject.color,"dash");		}				for (var f = 0; f< this._parent._parent.inLinkList.length; f++) {				var linkObject:Object = this._parent._parent.inLinkList[f];				// trace("outlist local object: " + linkObject.localFeature.label_internal);				 this._parent._parent.drawLinkLine(linkObject.localFeature, linkObject.remoteFeature, linkObject.color,"solid");		}	}					public function onRollOut(){		_root.featureInfo.text = "";		_root.link_layer.clear();		/*		if(_parent._parent._alpha == 100) {			this.drawBand(this._width,this._height,this.bandColor);			trace ("Redrawing band: " + String(this.bandColor));		}		*/	}		public function onReleaseOutside():Void {  				this.onRollOut();  	}			public function onPress(){			if(Key.isDown(Key.SHIFT)) {			trace("Shiftkey is down, Link = " + this.link);						if(this.link) {				hiliteStayOn = !hiliteStayOn;				var clickSound = new Sound();				clickSound.attachSound("clickSound2");				clickSound.start();				getURL(this.link, "_blank");			}			else {				_root.featureInfo.text = "[No link URL Defined in base map]";			}		}		else {					this._parent._parent.zoomIt();		}		}			}