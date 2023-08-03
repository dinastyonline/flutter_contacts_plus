package com.dinastyonline.flutter_contacts_plus

import android.content.ContentResolver
import android.database.ContentObserver
import android.os.Handler
import android.provider.ContactsContract
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer
import java.util.logging.StreamHandler


@Suppress("UNCHECKED_CAST")
private object StreamApiCodec : StandardMessageCodec() {
    override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
        return when (type) {
            128.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Account.fromList(it)
                }
            }
            129.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Address.fromList(it)
                }
            }
            130.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Contact.fromList(it)
                }
            }
            131.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    ContactsRequest.fromList(it)
                }
            }
            132.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Email.fromList(it)
                }
            }
            133.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Event.fromList(it)
                }
            }
            134.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Group.fromList(it)
                }
            }
            135.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Name.fromList(it)
                }
            }
            136.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Note.fromList(it)
                }
            }
            137.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Organization.fromList(it)
                }
            }
            138.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Phone.fromList(it)
                }
            }
            139.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    SocialMedia.fromList(it)
                }
            }
            140.toByte() -> {
                return (readValue(buffer) as? List<Any?>)?.let {
                    Website.fromList(it)
                }
            }
            else -> super.readValueOfType(type, buffer)
        }
    }
    override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
        when (value) {
            is Account -> {
                stream.write(128)
                writeValue(stream, value.toList())
            }
            is Address -> {
                stream.write(129)
                writeValue(stream, value.toList())
            }
            is Contact -> {
                stream.write(130)
                writeValue(stream, value.toList())
            }
            is ContactsRequest -> {
                stream.write(131)
                writeValue(stream, value.toList())
            }
            is Email -> {
                stream.write(132)
                writeValue(stream, value.toList())
            }
            is Event -> {
                stream.write(133)
                writeValue(stream, value.toList())
            }
            is Group -> {
                stream.write(134)
                writeValue(stream, value.toList())
            }
            is Name -> {
                stream.write(135)
                writeValue(stream, value.toList())
            }
            is Note -> {
                stream.write(136)
                writeValue(stream, value.toList())
            }
            is Organization -> {
                stream.write(137)
                writeValue(stream, value.toList())
            }
            is Phone -> {
                stream.write(138)
                writeValue(stream, value.toList())
            }
            is SocialMedia -> {
                stream.write(139)
                writeValue(stream, value.toList())
            }
            is Website -> {
                stream.write(140)
                writeValue(stream, value.toList())
            }
            else -> super.writeValue(stream, value)
        }
    }
}
/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface StreamApi {

    var resolver: ContentResolver?
    companion object {
        /** The codec used by ContactsHostApi. */
        val codec: MessageCodec<Any?> by lazy {
            StreamApiCodec
        }

        /** Sets up an instance of `ContactsHostApi` to handle messages through the `binaryMessenger`. */
        @Suppress("UNCHECKED_CAST")
        fun setUp(binaryMessenger: BinaryMessenger, api: StreamApi?) {
            run {
                var channel = EventChannel(binaryMessenger, "dev.flutter.pigeon.com.dinastyonline.flutter_contacts_plus.ContactsHostApi.listenContacts")

                if (api != null) {

                    channel.setStreamHandler(object : EventChannel.StreamHandler {
                        var eventObserver: ContactChangeObserver? = null
                        override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                            eventObserver = ContactChangeObserver(events)
                            api.resolver?.registerContentObserver(ContactsContract.Contacts.CONTENT_URI, true, eventObserver!!)
                        }

                        override fun onCancel(arguments: Any?) {
                            if (eventObserver != null) {
                                api.resolver?.unregisterContentObserver(eventObserver!!)
                            }
                            eventObserver = null
                        }
                    });
                } else {
                    channel.setStreamHandler(null)
                }
            }
        }
    }
}

class ContactChangeObserver : ContentObserver {
    val _sink: EventChannel.EventSink

    constructor(sink: EventChannel.EventSink) : super(Handler()) {
        this._sink = sink
    }

    override fun onChange(selfChange: Boolean) {
        super.onChange(selfChange)
        _sink?.success(selfChange)
    }
}