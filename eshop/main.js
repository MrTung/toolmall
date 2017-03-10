 console.log('JSPatch run success')

require("MyWebView, TextDataBase, Config, UIAlertView, JSWebView");

defineClass("IndexViewController", {
    onlineServiceBtnAction: function(sender) {
            
            console.log('111111111');
            

            var jsWebView = JSWebView.alloc().init();
            jsWebView.setNavTitle("工具节");
            var urlstr = "https://www.toolmall.com/app/index/secondActivity.jhtm?actid1=2&actid2=21&client=iOSApp";
            jsWebView.setLoadUrl(urlstr);
            jsWebView.setHidesBottomBarWhenPushed(YES);
            self.navigationController().pushViewController_animated(jsWebView, YES);


//			var myWebView = MyWebView.alloc().init();
//			var index_webView_navTitle = TextDataBase.shareTextDataBase().searchTextStrByModelPath("index_webView_navTitle");
//			myWebView.setNavTitle(index_webView_navTitle);
//			myWebView.setLoadUrl(Config.Instance().getUserInfo("onlineUrl"));
//			myWebView.setHidesBottomBarWhenPushed(YES);
//			self.navigationController().pushViewController_animated(myWebView, YES);
    }
}, {});
