package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.PlayerCustomizationMessage;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PlayerCustomizationSettingsMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SELECTEDDAUBICONID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage.selectedDaubIconId", "selectedDaubIconId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var selectedDaubIconId$field:int;

		private var hasField$0:uint = 0;

		public function clearSelectedDaubIconId():void {
			hasField$0 &= 0xfffffffe;
			selectedDaubIconId$field = new int();
		}

		public function get hasSelectedDaubIconId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set selectedDaubIconId(value:int):void {
			hasField$0 |= 0x1;
			selectedDaubIconId$field = value;
		}

		public function get selectedDaubIconId():int {
			return selectedDaubIconId$field;
		}

		/**
		 *  @private
		 */
		public static const SELECTEDCARDID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage.selectedCardId", "selectedCardId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var selectedCardId$field:int;

		public function clearSelectedCardId():void {
			hasField$0 &= 0xfffffffd;
			selectedCardId$field = new int();
		}

		public function get hasSelectedCardId():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set selectedCardId(value:int):void {
			hasField$0 |= 0x2;
			selectedCardId$field = value;
		}

		public function get selectedCardId():int {
			return selectedCardId$field;
		}

		/**
		 *  @private
		 */
		public static const SELECTEDAVATARID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage.selectedAvatarId", "selectedAvatarId", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var selectedAvatarId$field:int;

		public function clearSelectedAvatarId():void {
			hasField$0 &= 0xfffffffb;
			selectedAvatarId$field = new int();
		}

		public function get hasSelectedAvatarId():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set selectedAvatarId(value:int):void {
			hasField$0 |= 0x4;
			selectedAvatarId$field = value;
		}

		public function get selectedAvatarId():int {
			return selectedAvatarId$field;
		}

		/**
		 *  @private
		 */
		public static const SELECTEDVOICEOVERID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage.selectedVoiceOverId", "selectedVoiceOverId", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var selectedVoiceOverId$field:int;

		public function clearSelectedVoiceOverId():void {
			hasField$0 &= 0xfffffff7;
			selectedVoiceOverId$field = new int();
		}

		public function get hasSelectedVoiceOverId():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set selectedVoiceOverId(value:int):void {
			hasField$0 |= 0x8;
			selectedVoiceOverId$field = value;
		}

		public function get selectedVoiceOverId():int {
			return selectedVoiceOverId$field;
		}

		/**
		 *  @private
		 */
		public static const CUSTOMIZATIONS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.PlayerCustomizationSettingsMessage.customizations", "customizations", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.PlayerCustomizationMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.PlayerCustomizationMessage")]
		public var customizations:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasSelectedDaubIconId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, selectedDaubIconId$field);
			}
			if (hasSelectedCardId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, selectedCardId$field);
			}
			if (hasSelectedAvatarId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, selectedAvatarId$field);
			}
			if (hasSelectedVoiceOverId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, selectedVoiceOverId$field);
			}
			for (var customizations$index:uint = 0; customizations$index < this.customizations.length; ++customizations$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.customizations[customizations$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var selectedDaubIconId$count:uint = 0;
			var selectedCardId$count:uint = 0;
			var selectedAvatarId$count:uint = 0;
			var selectedVoiceOverId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (selectedDaubIconId$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerCustomizationSettingsMessage.selectedDaubIconId cannot be set twice.');
					}
					++selectedDaubIconId$count;
					this.selectedDaubIconId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (selectedCardId$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerCustomizationSettingsMessage.selectedCardId cannot be set twice.');
					}
					++selectedCardId$count;
					this.selectedCardId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (selectedAvatarId$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerCustomizationSettingsMessage.selectedAvatarId cannot be set twice.');
					}
					++selectedAvatarId$count;
					this.selectedAvatarId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (selectedVoiceOverId$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerCustomizationSettingsMessage.selectedVoiceOverId cannot be set twice.');
					}
					++selectedVoiceOverId$count;
					this.selectedVoiceOverId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					this.customizations.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.PlayerCustomizationMessage()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
