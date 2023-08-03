package com.dinastyonline.flutter_contacts_plus

import android.Manifest
import android.app.Activity
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

/** FlutterContactsPlusPlugin */
class FlutterContactsPlusPlugin: FlutterPlugin, ContactsHostApi, StreamApi, ActivityAware, RequestPermissionsResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private val service = ContactsService()
  override var resolver: ContentResolver? = null

  companion object {
    private var context: Context? = null
    private var act: Activity? = null
    private var PERMISIONS_CODE = 1515;
    private var permissionCallback: ((Boolean) -> Unit)? = null
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    resolver = context!!.contentResolver
    ContactsHostApi.setUp(flutterPluginBinding.binaryMessenger, this)
    StreamApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    act = binding.activity
    binding.addRequestPermissionsResultListener(this)
  }
  override fun onDetachedFromActivityForConfigChanges() {
    act = null;
  }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    act = binding.activity
    binding.addRequestPermissionsResultListener(this)
  }
  override fun onDetachedFromActivity() {
    act = null;
  }


  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
    when (requestCode) {
      PERMISIONS_CODE -> {
        val granted = grantResults.size == 2 && grantResults[0] == PackageManager.PERMISSION_GRANTED && grantResults[1] == PackageManager.PERMISSION_GRANTED
        permissionCallback?.let {
          it(granted)
          permissionCallback = null
        }
        return true
      }
    }
    return false // did not handle the result
  }

  private fun contactsByQuery(config: ContactsRequest, query: ContactsQuery?, callback: (kotlin.Result<List<Contact>>) -> Unit) {

    GlobalScope.launch(Dispatchers.IO) {
      var contacts = service.select(
              resolver!!,
              query,
              config,
              includeNonVisible = true
      )
      callback(Result.success(contacts))

    }
  }

  override fun getContacts(config: ContactsRequest, callback: (kotlin.Result<List<Contact>>) -> Unit) {
    contactsByQuery(config,null, callback)
  }

  override fun getContactsWithName(name: String, config: ContactsRequest, callback: (kotlin.Result<List<Contact>>) -> Unit) {

  }

  override fun getContactsWithEmail(email: String, config: ContactsRequest, callback: (kotlin.Result<List<Contact>>) -> Unit) {
    contactsByQuery(config,ContactsQueryByEmailAddress(email), callback)
  }

  override fun getContactsWithPhone(phone: String, config: ContactsRequest, callback: (kotlin.Result<List<Contact>>) -> Unit) {
    contactsByQuery(config,ContactsQueryByPhoneNumber(phone), callback)
  }

  override fun getContactsWithIds(ids: List<String>, config: ContactsRequest, callback: (kotlin.Result<List<Contact>>) -> Unit) {
    contactsByQuery(config,ContactsQueryByIds(ids), callback)
  }

  override fun getContactsInGroup(groupId: String, config: ContactsRequest, callback: (kotlin.Result<List<Contact>>) -> Unit) {
    contactsByQuery(config,ContactsQueryByGroup(groupId), callback)
  }

  override fun getContactsInContainer(containerId: String, config: ContactsRequest, callback: (kotlin.Result<List<Contact>>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun checkPermission(callback: (kotlin.Result<String>) -> Unit) {

    val readPermission = Manifest.permission.READ_CONTACTS
    val writePermission = Manifest.permission.WRITE_CONTACTS
    if (ContextCompat.checkSelfPermission(context!!, readPermission) == PackageManager.PERMISSION_GRANTED &&
            (ContextCompat.checkSelfPermission(context!!, writePermission) == PackageManager.PERMISSION_GRANTED)
    ) {
      callback(Result.success("authorized"))
      return
    }

    callback(Result.success("denied"))
  }

  override fun requestPermission(callback: (kotlin.Result<Boolean>) -> Unit) {
    fun dispatch(res: Boolean)  {
      GlobalScope.launch(Dispatchers.Main) {
        callback(kotlin.Result.success( res)) }
    }
    GlobalScope.launch(Dispatchers.IO) {
      if (context == null) {
        dispatch(false)
      } else {
        val readonly = false
        val readPermission = Manifest.permission.READ_CONTACTS
        val writePermission = Manifest.permission.WRITE_CONTACTS
        if (ContextCompat.checkSelfPermission(context!!, readPermission) == PackageManager.PERMISSION_GRANTED &&
                (readonly || ContextCompat.checkSelfPermission(context!!, writePermission) == PackageManager.PERMISSION_GRANTED)
        ) {
          dispatch(true)
        }
        var perms = mutableListOf<String>(readPermission)
        if (!readonly) {
          perms.add(writePermission)
        }
        permissionCallback = { dispatch(it) }

        act?.let {
          ActivityCompat.requestPermissions(it, perms.toTypedArray(), PERMISIONS_CODE)
        }
      }

    }
  }
}
