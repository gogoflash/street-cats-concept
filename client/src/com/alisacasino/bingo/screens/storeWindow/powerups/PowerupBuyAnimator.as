package com.alisacasino.bingo.screens.storeWindow.powerups
{
	import com.alisacasino.bingo.assets.AtlasAsset;
	import com.alisacasino.bingo.models.powerups.Powerup;
	import com.alisacasino.bingo.models.powerups.PowerupModel;
	import com.alisacasino.bingo.screens.storeWindow.powerups.PowerupsStoreContent;
	import com.theintern.beziertween.BezierTween;
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Canvas;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.geom.Polygon;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public class PowerupBuyAnimator
	{
		private const MIN_PARTICLES_COUNT:int = 18;
		private const MAX_PARTICLES_COUNT:int = 80;
		private const PARTICLES_VS_POWERUPS_COEFFICIENT:Number = 0.7;
		
		private var powerupsStoreContent:PowerupsStoreContent;
		
		public function PowerupBuyAnimator(powerupsStoreContent:PowerupsStoreContent)
		{
			this.powerupsStoreContent = powerupsStoreContent;
		}
		
		public function animate(pack:PowerupPackBase, powerupList:Object):void
		{
			var particlesCountPerPowerup:Number = 0;
			var particlesViewsTotalCount:int;
			var totalPowerupsQuantity:int;
			var powerupByTypeQuantity:int;
			
			var powerup:String;
			for (powerup in powerupList)
			{
				totalPowerupsQuantity += powerupList[powerup];
				powerupByTypeQuantity++;
			}	
			
			particlesViewsTotalCount = Math.min(MAX_PARTICLES_COUNT, Math.max(MIN_PARTICLES_COUNT, totalPowerupsQuantity * PARTICLES_VS_POWERUPS_COEFFICIENT));
			particlesCountPerPowerup = particlesViewsTotalCount / totalPowerupsQuantity;
			
			var remainParticlesCount:int = particlesViewsTotalCount;
			
			var powerupByTypeCounter:int;
			var particleViewsCountForPowerup:int;
			for (powerup in powerupList)
			{
				var powerupTotal:int = powerupList[powerup];
				
				particleViewsCountForPowerup = Math.max(1, Math.round(particlesCountPerPowerup * powerupTotal));
				remainParticlesCount -= particleViewsCountForPowerup;
				
				powerupByTypeCounter++;
				if (powerupByTypeCounter >= powerupByTypeQuantity) 
					particleViewsCountForPowerup += remainParticlesCount;
				
				if (particleViewsCountForPowerup < 1)
					particleViewsCountForPowerup = 1;
				
				//trace('new ', particleViewsCountForPowerup, particlesViewsTotalCount);
				
				var rarity:String = gameManager.powerupModel.getRarity(powerup);
				
				var targetIcon:PowerupIcon = getTarget(powerup, rarity);
					if (!targetIcon)
						continue;
				
				var targetPoint:Point = targetIcon.localToGlobal(new Point(80*pxScale, 70*pxScale));
					targetPoint = powerupsStoreContent.globalToLocal(targetPoint, targetPoint);
				
				var sourcePoint:Point = getSourcePoint(rarity, pack);
					if (!sourcePoint)
						continue;
				
				sourcePoint = pack.localToGlobal(sourcePoint, sourcePoint);
				sourcePoint = powerupsStoreContent.globalToLocal(sourcePoint, sourcePoint);
				
				var delay:Number = getRarityDelay(rarity, pack);
				
				var orbTextureForPowerup:Texture = getOrbTextureForPowerup(rarity);
				
				
				while (particleViewsCountForPowerup > 0)
				{
					var particleQuantity:int;
					
					if (particleViewsCountForPowerup == 1) {
						particleQuantity = powerupTotal;
					} 
					else 
					{
						particleQuantity = int(Math.random() * 2) + 1;
						if (powerupTotal < particleQuantity)
							particleQuantity = powerupTotal;
						
						powerupTotal -= particleQuantity;
					}
					
					particleViewsCountForPowerup--;
					//trace('-> ', particleQuantity, particlesViewsTotalCount);
					
					var icon:Sprite = new Sprite();
					var iconImage:Image = new Image(orbTextureForPowerup);
					iconImage.scale = 0.4*4;
					iconImage.alignPivot();
					icon.addChild(iconImage);
					
					Starling.juggler.delayCall(tweenIcon, delay + Math.random() * 0.4,  sourcePoint.clone(), targetPoint, icon, targetIcon, particleQuantity);
				}
				
				/*while (powerupTotal > 0)
				{
					var particleQuantity:int = int(Math.random() * 2) + 2;
					if (powerupTotal < particleQuantity)
					{
						particleQuantity = powerupTotal;
					}
					
					powerupTotal -= particleQuantity;
					
					var icon:Sprite = new Sprite();
					var iconImage:Image = new Image(orbTextureForPowerup);
					iconImage.scale = 0.4;
					iconImage.alignPivot();
					icon.addChild(iconImage);
					
					Starling.juggler.delayCall(tweenIcon, delay + Math.random() * 0.4,  sourcePoint.clone(), targetPoint, icon, targetIcon, particleQuantity);
				}*/
			}
		}
		
		private function getRarityDelay(rarity:String, pack:PowerupPackBase):Number
		{
			switch (rarity)
			{
				case Powerup.RARITY_NORMAL: 
					return pack.getNormalRarityDelay();
				case Powerup.RARITY_MAGIC: 
					return pack.getMagicRarityDelay();
				case Powerup.RARITY_RARE: 
					return pack.getRareRarityDelay();
			}
			return 0;
		}
		
		private function getOrbTextureForPowerup(rarity:String):Texture
		{
			var textureName:String;
			switch(rarity)
			{
				default:
				case Powerup.RARITY_NORMAL:
					textureName = "store/powerups/orb_green";
					break;
				case Powerup.RARITY_MAGIC:
					textureName = "store/powerups/orb_blue";
					break;
				case Powerup.RARITY_RARE:
					textureName = "store/powerups/orb_yellow";
					break;
			}
			
			return AtlasAsset.CommonAtlas.getTexture(textureName);
		}
		
		private function tweenIcon(sourcePoint:Point, targetPoint:Point, icon:DisplayObject, targetIcon:PowerupIcon, particleQuantity:int):void
		{
			
			sourcePoint.x += (Math.random() * 80 - 40) * pxScale;
			sourcePoint.y += (Math.random() * 100 - 50) * pxScale;
			icon.x = sourcePoint.x;
			icon.y = sourcePoint.y;
			powerupsStoreContent.animationLayer.addChildAt(icon, 0);
			
			var tweenTime:Number = Math.random() * 1 + 1;
			
			Starling.juggler.tween(icon, tweenTime / 3, {scale: Math.random() * 1 + 1});
			Starling.juggler.tween(icon, tweenTime * 2 / 3, {scale: 0.5, delay: tweenTime / 3});
			
			var anchorPoints:Vector.<Point> = new Vector.<Point>();
			anchorPoints.push(sourcePoint);
			anchorPoints.push(sourcePoint.add(new Point(Math.random() * 400 * pxScale - 100 * pxScale, Math.random() * 600 * pxScale - 300 * pxScale)));
			anchorPoints.push(targetPoint);
			var tween:BezierTween = new BezierTween(icon, tweenTime, anchorPoints, BezierTween.SPEED_DEFAULT, BezierTween.ACCURACY_FINE, Transitions.EASE_IN_OUT);
			//tween.delay = Math.random() * 0.3;
			tween.onComplete = countAndRemove;
			tween.onCompleteArgs = [tween, icon, targetIcon, particleQuantity];
			Starling.juggler.add(tween);
		}
		
		private function countAndRemove(tween:Tween, particle:DisplayObject, icon:PowerupIcon, quantity:int):void
		{
			Starling.juggler.remove(tween);
			particle.removeFromParent();
			icon.addQuantity(quantity);
		}
		
		private function getSourcePoint(rarity:String, pack:PowerupPackBase):Point
		{
			switch (rarity)
			{
				case Powerup.RARITY_NORMAL: 
					return pack.getNormalSourcePoint();
				case Powerup.RARITY_MAGIC: 
					return pack.getMagicSourcePoint();
				case Powerup.RARITY_RARE: 
					return pack.getRareSourcePoint();
			}
			return null;
		}
		
		private function getTarget(powerup:String, rarity:String):PowerupIcon
		{
			switch (rarity)
			{
				case Powerup.RARITY_NORMAL: 
					return powerupsStoreContent.commonInventory.getIcon(powerup);
				case Powerup.RARITY_MAGIC: 
					return powerupsStoreContent.magicInventory.getIcon(powerup);
				case Powerup.RARITY_RARE: 
					return powerupsStoreContent.rareInventory.getIcon(powerup);
			}
			return null;
		}
	
	}

}