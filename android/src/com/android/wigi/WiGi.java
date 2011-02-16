package com.android.wigi;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.Iterator;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.TextView;

import com.facebook.android.AsyncFacebookRunner;
import com.facebook.android.DialogError;

import com.facebook.android.Facebook;
import com.facebook.android.FacebookError;
import com.facebook.android.R;
import com.facebook.android.Util;
import com.facebook.android.AsyncFacebookRunner.RequestListener;
import com.facebook.android.Facebook.DialogListener;

public class WiGi extends Activity {
	
	//Facebook Application ID
	public static final String FACEBOOK_APPLICAITON_ID = "195151467166916";
	
	private Facebook myFacebook;
	private AsyncFacebookRunner mAsyncRunner;
	private ImageButton  loginButton;
	private TextView loginText;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
                
        //verify facebook applicaiton id
        if (FACEBOOK_APPLICAITON_ID == null) {
            Util.showAlert(this, "Warning", "Facebook Applicaton ID must be " +
                    "specified before running.");
        }
        
        setContentView(R.layout.main);        
        loginText = (TextView) WiGi.this.findViewById(R.id.login_text);
        myFacebook = new Facebook(FACEBOOK_APPLICAITON_ID);
        mAsyncRunner = new AsyncFacebookRunner(myFacebook);
        loginButton =  (ImageButton) findViewById(R.id.login);
        loginButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				myFacebook.authorize((Activity) v.getContext(), new AuthorizeListener());
			}             	
        });
    }

    private final class AuthorizeListener implements DialogListener {
    	  public void onComplete(Bundle values) {
    	   //  Handle a successful login
    		  Log.i("AuthorizeListener","OnComplete");
    		  mAsyncRunner.request("me", new RequestListener() {

				@Override
				public void onComplete(String response, Object state) {
					// TODO Auto-generated method stub
					 try {
			                // process the response here: executed in background thread
			                Log.i("AuthorizeListener", "Response: " + response.toString());
			                final JSONObject json = Util.parseJson(response);
			                final String name = json.getString("name");

			                // then post the processed result back to the UI thread
			                // if we do not do this, an runtime exception will be generated
			                // e.g. "CalledFromWrongThreadException: Only the original
			                // thread that created a view hierarchy can touch its views."
			                WiGi.this.runOnUiThread(new Runnable() {
			                    @SuppressWarnings("unchecked")
								public void run() {
			                    	loginText.setText("Hello, " + name);
			                    	for(Iterator i = json.keys(); i.hasNext(); )
			                    	{
			                    		String key = (String) i.next();
			                    		try {
											Log.i("AuthorizeListener","Key: " + key + " | Value: " + json.getString(key) + "\n" );
										} catch (JSONException e) {
											// TODO Auto-generated catch block
											e.printStackTrace();
										}
			                    	}
			                    	
			                    }
			                });
			            } catch (JSONException e) {
			                Log.i("AuthorizeListener", "JSON Error in response");
			            } catch (FacebookError e) {
			                Log.i("AuthorizeListener", "Facebook Error: " + e.getMessage());
			            }
			        }
				
				public void onFacebookError(FacebookError e, Object state) {
					// TODO Auto-generated method stub
					
				}

				@Override
				public void onFileNotFoundException(FileNotFoundException e,
						Object state) {
					// TODO Auto-generated method stub
					
				}

				@Override
				public void onIOException(IOException e, Object state) {
					// TODO Auto-generated method stub
					
				}

				@Override
				public void onMalformedURLException(MalformedURLException e,
						Object state) {
					// TODO Auto-generated method stub
					
				}
    			  
    			  
    			  
    		  });
    	  }

		@Override
		public void onCancel() {
			// TODO Auto-generated method stub
			Log.i("AuthorizeListener","OnCancel()");
			
		}

		@Override
		public void onError(DialogError e) {
			// TODO Auto-generated method stub
			Log.i("AuthorizeListener","OnError()");
		}

		@Override
		public void onFacebookError(FacebookError e) {
			// TODO Auto-generated method stub
			
		}
    }
    
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
      super.onActivityResult(requestCode, resultCode, data);
      myFacebook.authorizeCallback(requestCode, resultCode, data);
      // ... anything else your app does onActivityResult ...
    }
}