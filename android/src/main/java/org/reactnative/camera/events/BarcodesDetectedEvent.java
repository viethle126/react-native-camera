package org.reactnative.camera.events;

import android.support.v4.util.Pools;
import android.util.SparseArray;
import android.graphics.Rect;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.google.android.gms.vision.barcode.Barcode;
import org.reactnative.camera.CameraViewManager;
import org.reactnative.camera.utils.ImageDimensions;
import org.reactnative.barcodedetector.BarcodeFormatUtils;

public class BarcodesDetectedEvent extends Event<BarcodesDetectedEvent> {

  private static final Pools.SynchronizedPool<BarcodesDetectedEvent> EVENTS_POOL =
      new Pools.SynchronizedPool<>(3);

  private double mScaleX;
  private double mScaleY;
  private SparseArray<Barcode> mBarcodes;
  private ImageDimensions mImageDimensions;

  private BarcodesDetectedEvent() {
  }

  public static BarcodesDetectedEvent obtain(
      int viewTag,
      SparseArray<Barcode> barcodes,
      ImageDimensions dimensions,
      double scaleX,
      double scaleY
  ) {
    BarcodesDetectedEvent event = EVENTS_POOL.acquire();
    if (event == null) {
      event = new BarcodesDetectedEvent();
    }
    event.init(viewTag, barcodes, dimensions, scaleX, scaleY);
    return event;
  }

  private void init(
      int viewTag,
      SparseArray<Barcode> barcodes,
      ImageDimensions dimensions,
      double scaleX,
      double scaleY
  ) {
    super.init(viewTag);
    mBarcodes = barcodes;
    mImageDimensions = dimensions;
    mScaleX = scaleX;
    mScaleY = scaleY;
  }

  /**
   * note(@sjchmiela)
   * Should the events about detected barcodes coalesce, the best strategy will be
   * to ensure that events with different barcodes count are always being transmitted.
   */
  @Override
  public short getCoalescingKey() {
    if (mBarcodes.size() > Short.MAX_VALUE) {
      return Short.MAX_VALUE;
    }

    return (short) mBarcodes.size();
  }

  @Override
  public String getEventName() {
    return CameraViewManager.Events.EVENT_ON_BARCODES_DETECTED.toString();
  }

  @Override
  public void dispatch(RCTEventEmitter rctEventEmitter) {
    rctEventEmitter.receiveEvent(getViewTag(), getEventName(), serializeEventData());
  }

  private WritableMap serializeEventData() {
    WritableArray barcodesList = Arguments.createArray();

    for (int i = 0; i < mBarcodes.size(); i++) {
      Barcode barcode = mBarcodes.valueAt(i);
      WritableMap serializedBarcode = Arguments.createMap();
      serializedBarcode.putString("data", barcode.displayValue);
      serializedBarcode.putString("type", BarcodeFormatUtils.get(barcode.format));

      WritableMap origin = Arguments.createMap();
      origin.putDouble("x", barcode.getBoundingBox().left * this.mScaleX);
      origin.putDouble("y", barcode.getBoundingBox().top * this.mScaleY);

      WritableMap size = Arguments.createMap();
      size.putDouble("width", barcode.getBoundingBox().width() * this.mScaleX);
      size.putDouble("height", barcode.getBoundingBox().height() * this.mScaleY);

      WritableMap bounds = Arguments.createMap();
      bounds.putMap("origin", origin);
      bounds.putMap("size", size);

      serializedBarcode.putMap("bounds", bounds);
      barcodesList.pushMap(serializedBarcode);
    }

    WritableMap event = Arguments.createMap();
    event.putString("type", "barcode");
    event.putArray("barcodes", barcodesList);
    event.putInt("target", getViewTag());
    return event;
  }
}
