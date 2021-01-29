// 公共函数
        /**
         * touchend消除点击击穿
         * */
        function stopCross(){
            var locked = false;
            window.addEventListener('touchmove', function(ev){
                locked || (locked = true, window.addEventListener('touchend', stopTouchendPropagation, true));
            }, true);
            function stopTouchendPropagation(ev){
                ev.stopPropagation();
                window.removeEventListener('touchend', stopTouchendPropagation, true);
                locked = false;
            }
        }
/*
* 序列化表格
*/ 
function formToSerialize(ele){
    let obj = {}
    let form = $(ele).serializeArray()
    $.each(form,function(){
        obj[this.name] = this.value
    })
    return obj
}
 /**
         * 操作反馈
         * */
        function addToast(_content){
            $('#centerTips').html(_content);
            $('#centerTips').show();
            setTimeout(()=>{
                $('#centerTips').hide();
            },3000)
        }
/*------------------END------------------*/ 
/*oil首页返回*/
$('.oil-back').on('touchend',function(){
    $('.oil').hide()
    $('.home-oil').show()
}) 
//退出系统
$('.exit-gas').on('touchend',function(){
    stopCross()
    $('.home-oil').hide()
    $('.weui-tab-edit').removeClass('page-hide')
})
/*tab切换*/
$('.tab-group').on('touchend',function(){
    stopCross()
    $('.tab-group').find('p').removeClass('tab-on')
    $('.oil-page-group').find('.oil-group').hide()
    $('.tab-group').find('div img').each(function(index){
       $(this).attr('src',iconUnActive($(this).attr('src')))
    })

    $(this).find('p').addClass('tab-on')
    switch($(this).index()){
        case 0:
            $('.oil-page-group').find('.oil-group').eq(0).show()
            break;
        case 1:
            $('.oil-page-group').find('.oil-group').eq(1).show()
            break;
        case 2:
            $('.oil-page-group').find('.oil-group').eq(2).show()
            break;
        case 3:
            $('.oil-page-group').find('.oil-group').eq(3).show()
            break;
    }
    $(this).find('div img').attr('src',iconAxtive($(this).find('div img').attr('src')))
 })

 function iconAxtive(src){
    let len = src.indexOf('_')
    let newSrc = src.substring(0,len)+'_a.png' 
    return newSrc
 }
 function iconUnActive(src){
    let len = src.indexOf('_')
    let newSrc = src.substring(0,len)+'_c.png' 
    return newSrc
 }

// //tab切换
// let i=0;
// setInterval(function(){
//     if(i>2){
//         i=0
//     }
//     $('.nav-pic').find('.nav-calual').hide()
//     $('.nav-pic').find('.nav-calual').eq(i++).show()
// },3000)

/*END*/
/*首页-加油站详情-操作*/ 
$(document).on('touchend','.oil-data .oil-data-item',function(){
    stopCross()
    $('.home-oil').hide()
    $('.oil-detail').show()
})
/*首页-详情*/ 
$(document).on('touchend','.oil-type .oil-type-item',function(){
    stopCross()
    $('.oil-type-item').css('color','black')
    $(this).css('color','#d50100')
    $('#oil-goods').val($(this).html())
})
$(document).on('touchend','.oil-num .oil-num-item',function(){
    stopCross()
    $('.oil-num-item').css('color','black')
    $(this).css('color','#d50100')
    $('#oil-num').val($(this).html())
})
$(document).on('touchend','.oil-gun .oil-gun-item',function(){
    stopCross()
    $('.oil-gun-item').css('color','black')
    $(this).css('color','#d50100')
    $('#oil-gun').val($(this).html())
})
$('#oil-consume').on('focus',function(){
    $(this).css('borderColor','#d50100')
})
$('#oil-consume').on('blur',function(){
    $(this).css('borderColor','gray')
})
$('.oil-flex').on('touchstart',function(){
    $(this).attr('backgroundColor','#eee')
    setTimeout(() => {
        $(this).attr('backgroundColor','white')
    }, 500);
})
$('.oil-flex').on('touchend',function(){
    stopCross()
    $('#pay-method').val($(this).data('pay'))
    $('#mine-pay-method').val($(this).data('minepay'))
    $('.oil-flex').find('.oil-pay-radio').html('<i class="weui-icon-circle"></i>')
    $(this).find('.oil-pay-radio').html('<i class="weui-icon-success-circle pay-icon"></i>')
})
$('.oil-cash-num').on('touchend',function(){
    stopCross()
    $('.oil-cash-num').val($(this).data('val'))
})
// 提交支付
$('#submit-for-pay').on('touchend',function(){
    stopCross()
    if(!$('input[name="consume"]').val()){
        addToast('消费金额异常')
        $('input[name="consume"]').focus()
        return
    }
    //拿到表单数据
    let obj = formToSerialize('#form-station-detail')
    console.log(obj)
    //渲染数据
    $('#oil-num-actull').html(obj.num)
    $('#oil-pay-actull').html(obj.payMethod)
    $('#oil-consume-actull').html('￥'+obj.consume)
    $('.oil-detail').hide()
    $('.oil-cash-pay').show()
})
// END
/*首页-订单支付*/
$('.oil-detail-back').on('touchend',function(){
    stopCross()
    $('.oil-cash-pay').hide()  
    $('.oil-detail').show()
})
/*订单页*/
$(document).on('touchend','.oil-data-order',function(){
    stopCross()
    $('.home-oil').hide()
    $('.oil-order-detail').show()
}) 
// END

/*我的*/
$('.oil-menu-top').on('touchend',function(e){
    stopCross()
    let filter = e.target.className.split(/\s+/)
    switch(filter[filter.length-1]){
        case 'menu-recharge':
            $('.home-oil').hide()
            $('.oil-mine-recharge').show()
            break;
        case 'mine-recommend':
            $('.home-oil').hide()
            $('.oil-mine-recommend').show()
            break
        case 'mine-invitation':
            $('.home-oil').hide()
            $('.oil-mine-invitation').show()
            break
        default:
            break
    }
})
$('.oil-menu-bottom').on('touchend',function(e){
    stopCross()
    switch(e.target.className){
        case 'certify':
            $('.home-oil').hide()
            $('.oil-mine-certify').show()
            break;
        case 'help':
            $('.home-oil').hide()
            $('.oil-mine-help').show()
            break
        case 'answer':
            $('.home-oil').hide()
            $('.oil-mine-ask').show()
            break
        default:
            break
    }
})
$('.oil-mine-msg-btn').on('touchend',function(){
    stopCross()
    $('.home-oil').hide()
    $('.oil-mine-msg11').show()
})
$('.fade-problem').on('touchend',function(){
    $(this).find('.toggle-problem').stop().slideToggle()
}) 
// END

// 我的-充值
$('.oil-pay-method').find('.oil-flex').on('touchend',function(){
    stopCross()
    $('input[name="payMethod"]').val($(this).data('minepay'))
})
$('.oil-nums').find('.d-cash-item').on('touchend',function(){
    stopCross()
    $('.d-input-val').val($(this).data('val'))
})
// 确认支付
$('.c-confirm-recharge').on('touchend',function(){
    stopCross()
    if(!$('.d-input-val').val()){
        addToast('充值金额异常')
        return
    }
    let obj = formToSerialize('#form-recharge')
    console.log(obj)
})
//推荐入驻
$('.d-commend-submit').on('touchend',function(){
    stopCross()
    let obj = formToSerialize("#form-commend")
    console.log(obj)
})