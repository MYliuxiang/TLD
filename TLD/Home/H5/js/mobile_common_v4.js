/**
 * 提交数据
 * @param url       提交地址
 * @param data      数据内容Json
 * @param func_s    success后回调
 * @param func_c    complate后回调
 */
var postData_comm = function (url,data,func_s,func_c) {
    $.ajax({
        type: "POST",
        url: url,
        data: data,
        dataType: "json",
        success:function (data) {
            if(func_s!=null) func_s(data);
        },
        error:function(req,text,thr){
        },
        complete:function(req,text){
            if(func_c!=null) func_c(req,text);
        }
    })
}
  //headers:{'Content-Type':'application/json'},
/**
 * 序列化表单为json
 */
$.fn.serializeObject_comm = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

/**
 * 格式化时间
 * @param timefmt   时间戳
 * @returns {string}
 */
var getValidDate_comm = function(timefmt){
    var d = new Date();
    d.setTime(timefmt);
    var seperator1 = "-";
    var year = d.getFullYear();
    var month = d.getMonth() + 1;
    var strDate = d.getDate();
    var hour = d.getHours();
    var minints = d.getMinutes();
    month =month>9?month:'0'+month;
    strDate = strDate>9?strDate:'0'+strDate;
    hour = hour>9?hour:'0'+hour;
    minints = minints>9?minints:'0'+minints;
    var currentdate = year + seperator1 + month + seperator1 + strDate+" "+hour+":"+minints;
    return currentdate;
}

/**
 * 设置cookie
 * @param name cookie名称
 * @param value 数值
 * @param expire 有效期 秒
 */
function setCookie_comm(name,value,expire) {
    if(expire==0){
        document.cookie = name + "=" + encodeURI(value) + ";";
    }
    else
    {
        var exp = new Date();
        exp.setTime(exp.getTime() + expire * 1000);
        document.cookie = name + "=" + encodeURI(value) + ";expires=" + exp.toGMTString();
    }
}
/**
 * 读取cookie
 * @param c_name 名称
 * @returns {*} 数值
 */
function getCookie_comm(c_name){
    if (document.cookie.length>0)
    {
        c_start=document.cookie.indexOf(c_name + "=")
        if (c_start!=-1)
        {
            c_start=c_start + c_name.length+1
            c_end=document.cookie.indexOf(";",c_start)
            if (c_end==-1) c_end=document.cookie.length
            return decodeURI(document.cookie.substring(c_start,c_end))
        }
    }
    return null;
}


// 校验手机号
var isMobile_comm = function(str) {
    if(str==null || str.length==0) return false;
    var re = /^1\d{10}$/
    if (re.test(str))   return true;
    else return false;
}

/**
 * 正则数字
 * @param value
 * @returns {boolean}
 */