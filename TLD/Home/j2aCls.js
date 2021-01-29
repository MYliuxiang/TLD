var j2aCls = new Object()
//获取手机定位信息
j2aCls.GetLocation = function(){
    try{
       return window.prompt("getlocation");
    }catch(e){
        alert(e.message)
    }
}
//存储token
j2aCls.SetToken = function(token){
    try{
        window.webkit.messageHandlers.j2aCls.postMessage({"name":"SetToken","token":token})
       return window.prompt("getlocation");
        
    }catch(e){
        alert(e.message)
    }
}

//获取token
j2aCls.GetToken = function(){
    try{
       return window.prompt("GetToken");
    }catch(e){
        alert(e.message)
    }
}
//前端数据请求
j2aCls.SendMsgViaHost = function(obj){
    try{
        window.webkit.messageHandlers.j2aCls.postMessage({"name":"SendMsgViaHost","obj":obj})
        
        
    }catch(e){
        alert(e.message)
    }
}

//相册上传图片
j2aCls.DoSelectPictrue = function(idCard,obj){
    try{
        window.webkit.messageHandlers.j2aCls.postMessage({"name":"DoSelectPictrue","idCard":idCard,"obj":obj})
        
    }catch(e){
        alert(e.message)
    }
}

//扫码功能
j2aCls.OpenScaner = function(){
    try{
        
        window.webkit.messageHandlers.j2aCls.postMessage({"name":"OpenScaner"})
        
    }catch(e){
        alert(e.message)
    }
}

//拉起微信支付
j2aCls.PaywithWxpay = function(message){
    try{
        window.webkit.messageHandlers.j2aCls.postMessage({"name":"PaywithWxpay","message":message})
        
       return window.prompt("getlocation");
        
    }catch(e){
        alert(e.message)
    }
}

//拉起支付宝支付
j2aCls.PaywithAlipay = function(message){
    try{
        window.webkit.messageHandlers.j2aCls.postMessage({"name":"PaywithAlipay","message":message})
        
        
    }catch(e){
        alert(e.message)
    }
}

//调用手机导航
j2aCls.OpenNavigation = function(lat,lng){
    try{
        window.webkit.messageHandlers.j2aCls.postMessage({"name":"OpenNavigation","lat":lat,"lng":lng})
        
       return window.prompt("getlocation");
        
    }catch(e){
        alert(e.message)
    }
}

//签字板
j2aCls.OpenSignatureBoard = function(){
    try{
        window.webkit.messageHandlers.j2aCls.postMessage({"name":"OpenSignatureBoard"})
        
        
    }catch(e){
        alert(e.message)
    }
}

//查看电子运输合同
j2aCls.ShowContactDocument = function(url){
    try{
        window.webkit.messageHandlers.j2aCls.postMessage({"name":"ShowContactDocument","url":url})
        
    }catch(e){
        alert(e.message)
    }
}






