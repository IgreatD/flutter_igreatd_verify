package com.umeng.umeng_verify_sdk_example;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Build;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Toolbar;

import androidx.annotation.RequiresApi;

import com.umeng.umverify.UMConstant;


/**
 * @ProjectName: NumberAuthSDK_Standard_Android
 * @Package: com.aliqin.mytel.auth
 * @ClassName: CustomWebView
 * @Description: 自定义协议展示页
 * @Author: liuqi
 * @CreateDate: 2021/3/25 4:04 PM
 * @Version: 1.0
 */
public class CustomWebViewActivity extends Activity {
    private WebView mWebView;
    private Toolbar mToolbar;

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_custom_web);
        String mUrl = getIntent().getStringExtra(UMConstant.PROTOCOL_WEBVIEW_URL);
        String mName = getIntent().getStringExtra(UMConstant.PROTOCOL_WEBVIEW_NAME);
        setRequestedOrientation(
                getIntent().getIntExtra(UMConstant.PROTOCOL_WEBVIEW_ORIENTATION, ActivityInfo.SCREEN_ORIENTATION_PORTRAIT));
        mWebView = findViewById(R.id.webView);
        mToolbar = findViewById(R.id.toolbar);

        mToolbar.setSubtitle(mName);
        initWebView();
        mWebView.loadUrl(mUrl);
    }

    private void initWebView() {
        WebSettings wvSettings = mWebView.getSettings();
        // 是否阻止网络图像
        wvSettings.setBlockNetworkImage(false);
        // 是否阻止网络请求
        wvSettings.setBlockNetworkLoads(false);
        // 是否加载JS
        wvSettings.setJavaScriptEnabled(true);
        wvSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        //覆盖方式启动缓存
        wvSettings.setCacheMode(WebSettings.LOAD_DEFAULT);
        // 使用广泛视窗
        wvSettings.setUseWideViewPort(true);
        wvSettings.setLoadWithOverviewMode(true);
        wvSettings.setDomStorageEnabled(true);
        //是否支持缩放
        wvSettings.setBuiltInZoomControls(false);
        wvSettings.setSupportZoom(false);
        //不显示缩放按钮
        wvSettings.setDisplayZoomControls(false);
        wvSettings.setAllowFileAccess(true);
        wvSettings.setDatabaseEnabled(true);
        //缓存相关
        wvSettings.setAppCacheEnabled(true);
        wvSettings.setDomStorageEnabled(true);
        wvSettings.setDatabaseEnabled(true);
    }
}
