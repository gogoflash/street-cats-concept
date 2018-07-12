package com.alisacasino.bingo.protocol {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.alisacasino.bingo.protocol.RoomCollectionObjectiveMessage;
	import com.alisacasino.bingo.protocol.CommodityItemMessage;
	import com.alisacasino.bingo.protocol.ItemFoundObjectiveMessage;
	import com.alisacasino.bingo.protocol.ObjectiveType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ObjectiveMessage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.alisacasino.bingo.protocol.ObjectiveMessage.id", "id", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:uint;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.ObjectiveMessage.name", "name", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const GRAPHICS_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.alisacasino.bingo.protocol.ObjectiveMessage.graphics_name", "graphicsName", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var graphicsName:String;

		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.alisacasino.bingo.protocol.ObjectiveMessage.type", "type", (4 << 3) | com.netease.protobuf.WireType.VARINT, com.alisacasino.bingo.protocol.ObjectiveType);

		public var type:int;

		/**
		 *  @private
		 */
		public static const PRIZES:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ObjectiveMessage.prizes", "prizes", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.CommodityItemMessage; });

		[ArrayElementType("com.alisacasino.bingo.protocol.CommodityItemMessage")]
		public var prizes:Array = [];

		/**
		 *  @private
		 */
		public static const ROOM_COLLECTION_OBJECTIVE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ObjectiveMessage.room_collection_objective", "roomCollectionObjective", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.RoomCollectionObjectiveMessage; });

		private var room_collection_objective$field:com.alisacasino.bingo.protocol.RoomCollectionObjectiveMessage;

		public function clearRoomCollectionObjective():void {
			room_collection_objective$field = null;
		}

		public function get hasRoomCollectionObjective():Boolean {
			return room_collection_objective$field != null;
		}

		public function set roomCollectionObjective(value:com.alisacasino.bingo.protocol.RoomCollectionObjectiveMessage):void {
			room_collection_objective$field = value;
		}

		public function get roomCollectionObjective():com.alisacasino.bingo.protocol.RoomCollectionObjectiveMessage {
			return room_collection_objective$field;
		}

		/**
		 *  @private
		 */
		public static const ITEM_FOUND_OBJECTIVE:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.alisacasino.bingo.protocol.ObjectiveMessage.item_found_objective", "itemFoundObjective", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.alisacasino.bingo.protocol.ItemFoundObjectiveMessage; });

		private var item_found_objective$field:com.alisacasino.bingo.protocol.ItemFoundObjectiveMessage;

		public function clearItemFoundObjective():void {
			item_found_objective$field = null;
		}

		public function get hasItemFoundObjective():Boolean {
			return item_found_objective$field != null;
		}

		public function set itemFoundObjective(value:com.alisacasino.bingo.protocol.ItemFoundObjectiveMessage):void {
			item_found_objective$field = value;
		}

		public function get itemFoundObjective():com.alisacasino.bingo.protocol.ItemFoundObjectiveMessage {
			return item_found_objective$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.id);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.graphicsName);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.type);
			for (var prizes$index:uint = 0; prizes$index < this.prizes.length; ++prizes$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.prizes[prizes$index]);
			}
			if (hasRoomCollectionObjective) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, room_collection_objective$field);
			}
			if (hasItemFoundObjective) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, item_found_objective$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var name$count:uint = 0;
			var graphics_name$count:uint = 0;
			var type$count:uint = 0;
			var room_collection_objective$count:uint = 0;
			var item_found_objective$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: ObjectiveMessage.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: ObjectiveMessage.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (graphics_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: ObjectiveMessage.graphicsName cannot be set twice.');
					}
					++graphics_name$count;
					this.graphicsName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: ObjectiveMessage.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 7:
					this.prizes.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.alisacasino.bingo.protocol.CommodityItemMessage()));
					break;
				case 5:
					if (room_collection_objective$count != 0) {
						throw new flash.errors.IOError('Bad data format: ObjectiveMessage.roomCollectionObjective cannot be set twice.');
					}
					++room_collection_objective$count;
					this.roomCollectionObjective = new com.alisacasino.bingo.protocol.RoomCollectionObjectiveMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.roomCollectionObjective);
					break;
				case 6:
					if (item_found_objective$count != 0) {
						throw new flash.errors.IOError('Bad data format: ObjectiveMessage.itemFoundObjective cannot be set twice.');
					}
					++item_found_objective$count;
					this.itemFoundObjective = new com.alisacasino.bingo.protocol.ItemFoundObjectiveMessage();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.itemFoundObjective);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
