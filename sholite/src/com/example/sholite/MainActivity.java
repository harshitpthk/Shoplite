package com.example.sholite;


import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.hardware.Camera;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.Toast;
import eu.livotov.zxscan.ZXScanHelper;

public class MainActivity extends Activity {

	private Camera mCamera;
	private CameraPreview mPreview;
	
	LayoutInflater inflater;
	ViewGroup container;
	 
     
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        View view=inflater.inflate(R.layout.scanner_layout,container, false);
//        
//        final DrawerLayout mdrawerLayout = (DrawerLayout)view.findViewById(R.id.drawer_layout);
//        final LinearLayout ldrawer = (LinearLayout)view.findViewById(R.id.left_drawer);
//        mdrawerLayout.setOnClickListener(new OnClickListener() {
//
//            @Override
//           public void onClick(View v) {
//
//            	mdrawerLayout.openDrawer(ldrawer);
//
//            	}
//        	});
//            
        setContentView(R.layout.activity_main);
      
       // boolean result = checkCameraHardware();
        
       // Camera.Parameters params = mCamera.getParameters();

       // List<String> focusModes = params.getSupportedFocusModes();
       
       // Toast.makeText(this, "Camera availibility "+result, Toast.LENGTH_SHORT).show();
       // mCamera = getCameraInstance();
       // mCamera.setDisplayOrientation(90);
    	//mPreview = new CameraPreview(this, mCamera);
        //FrameLayout preview = (FrameLayout) findViewById(R.id.camera_preview);
        //preview.addView(mPreview);
      
    	//Intent intent = new Intent("com.google.zxing.client.android.SCAN");
    	//intent.putExtra("SCAN_MODE", "QR_CODE_MODE");
    	
    	//startActivityForResult(intent,0);
      //  if (focusModes.contains(Camera.Parameters.FOCUS_MODE_AUTO)) {
            // Autofocus mode is supported
        	// params.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
      //    }
      
      //  ZXScanHelper.setCustomScanSound(R.raw.atone);
       
      
       
       // ZXScanHelper.scan(this,0);
        

    	
    }
    
    public void start_signup(View v)
    {
    	//Toast.makeText(this, " signup activity to start", Toast.LENGTH_SHORT).show();
    	Intent intent = new Intent(this, SignupActivity.class);
    	startActivity(intent);
    }
    
    public void start_login(View v)
    {
    	Toast.makeText(this, "Login activity to start", Toast.LENGTH_SHORT).show();
    	Intent intent = new Intent(this, SigninActivity.class);
    	startActivity(intent);
    	
    }
    
    
    
    public static Camera getCameraInstance(){
	    Camera c = null;
	    try {
	        c = Camera.open(); // attempt to get a Camera instance
	    }
	    catch (Exception e){
	        // Camera is not available (in use or does not exist)
	    }
	    return c; // returns null if camera is unavailable
	}

    private boolean checkCameraHardware() {
        if (getApplicationContext().getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)){
            // this device has a camera
            return true;
        } else {
            // no camera on this device
            return false;
        }
    }
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		   if (requestCode == 0) {
		      if (resultCode == RESULT_OK) {
		        // String contents = intent.getStringExtra("SCAN_RESULT");
		         String format = intent.getStringExtra("SCAN_RESULT_FORMAT");
		         // Handle successful scan
		         String scannedCode = ZXScanHelper.getScannedCode(intent);
		         Toast.makeText(this, "returned OK" + scannedCode, Toast.LENGTH_SHORT).show();
		         
		         
		      } else if (resultCode == RESULT_CANCELED) {
		         // Handle cancel
		    	  Toast.makeText(this, "returned null  ", Toast.LENGTH_SHORT).show();
		      }
		   }
		}

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
   
    
}
