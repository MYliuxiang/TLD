/*公共函数*/
/*定义全局属性*/
var current_page=null;
var bank_current_page=null;
var iscar=0;//为0表示为车主页，为1表示货主页。
var isToptabCarDetails=0;//车辆管理详情与我的-车辆管理详情
var isGoodsResource=1;//为1表示货主-货源页，为0表示货主-订单页
var satrt_postition='';
var resource_page=0;//为0表示进入首页-车主-货源大厅，为1表示进入货源页
var postition_choose_page=0;//为0表示进入起始位置页，否则进入目的地页
/*滑动监听,头部tab操作*/
function stopTouchendPropagationAfterScroll(){
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
// $(window).on('touchmove',function () {
//     var  lunbo=$('.swiper-container').offset().top;
//     //110
//     if(lunbo<=-110){
//         $('.page__bd').css({
//             position:'fixed',
//             top:0
//         })
//     }else{
//         $('.page__bd').css({
//             position: 'absolute',
//             top:'110px'
//         })
//     }
// })

/*************************************************/

/*首页*/

$(function () {
    var top=0;
    setInterval(function () {
        $('.swiper-wrapper').css({
            top:-top+'px'
        });
        var index=0;
        if(top==0){
            index=0;
        }else if(top==150){
            index=1;
        }else{
            index=2;
        }
        $('.swiper-pagination').find('span').css({
            opacity:0.4
        }).eq(index).css({
            opacity:1
        })
        top+=150;
        if(top>300){top=0;}
    },3000);

})
$(function(){
    $('.weui-navbar-item').on('touchend', function () {
        stopTouchendPropagationAfterScroll();
        $(this).addClass('nav-on').siblings('.nav-on').removeClass('nav-on');
        $(jQuery(this).attr("href")).show().siblings('.weui-tab__content').hide();
    });
});
/***************************************/
/*货源页*/
$(".page-back").on('touchend',function () {
    stopTouchendPropagationAfterScroll();
    $(".weui-tab-edit").removeClass('page-hide');
    $('.page_goods_filter').css('display','none')
})
/****************************************/
/*订单页*/
/*省市县三级联动*/
$(".pick-area4").pickArea({
    "format": "四川省/德阳市/旌阳区",
    "width": "240",
    "borderColor": "white",
    "arrowColor": "white",
    "listBdColor": "white",
    "color": "black",
    "fontSize": "12px",
    "maxHeight": "280px",
    "getVal": function () {
        var thisdom = $("." + $(".pick-area-dom").val());
        thisdom.next().val($(".pick-area-hidden").val());
    }
});
$(".pick-area5").pickArea({
    "format": "北京市/市区",
    "width": "160",
    "borderColor": "white",
    "arrowColor": "white",
    "listBdColor": "white",
    "color": "#03A4D6",
    "fontSize": "14px",
    "maxHeight": "280px",
    "getVal": function () {
        var thisdom = $("." + $(".pick-area-dom").val());
        thisdom.next().val($(".pick-area-hidden").val());
        var arr=$(".pick-area-hidden").val().split(' ')
        satrt_postition=arr.join('');
        $("#region").val(arr[arr.length-1]);
        if(arr[arr.length-1]=="市辖区"){
        }else{
            searchKeyword();
        }
    }
});
$('.oil-func-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll();
    $('.home-oil-func').css('display', 'none');
    $('.home-oil').css('display', 'block')
})
/*车价询问*/
$('.insurance-ask').on('touchend', function () {
    stopTouchendPropagationAfterScroll();
    $('.home-insurance').css('display', 'none');
    $('.home-insurance-ask').css('display', 'block')
})
$('.home-insurance-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll();
    $('.home-insurance').css('display', 'block');
    $('.home-insurance-ask').css('display', 'none')
})
$(".postition-back").on('touchend',function () {
    stopTouchendPropagationAfterScroll();
    $(".home-goods-release").css("display",'block')
    $(".selected_postition").css('display','none');
})
/***********车主-我的************************/
/*车主-我的-功能*/
$(function () {
    var $androidActionSheet = $('#androidActionsheet');
    var $androidMask = $androidActionSheet.find('.weui-mask');
    $('.weui-mask-child').on('touchend', function (e) {
        e.stopPropagation();
    })
    $("#showAndroidActionSheet").on('touchend', function () {
        stopTouchendPropagationAfterScroll();
        $androidActionSheet.fadeIn(200);
        $androidMask.on('touchend', function () {
            $androidActionSheet.fadeOut(200);
        });
    });
})
$('.mine-personal_info').on('touchend', function () {
    stopTouchendPropagationAfterScroll();
    $('.home-car-mine').css('display', 'none');
    $('.home-goods-mine').css('display', 'none');
    $('.personal_info').css('display', 'block')
})
$('.car-func-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll();
    $('.car-fun-group').css('display', 'none');
    $('.home-car-mine').css('display', 'block')
})
$('.block-change-pwd').on('touchend', function () {
    stopTouchendPropagationAfterScroll();
    $('.personal_info').css('display', 'none');
    $('.personal-change-pwd').css('display', 'block')
})
$('.personal-func-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll();
    $('.personal_info').css('display', 'block');
    $('.personal-change-pwd').css('display', 'none')
})
$('.personal-photo').on('touchstart', function () {
    $(this).css('opacity', '.5')
})
$(".personal-photo").on('touchend', function () {
    stopTouchendPropagationAfterScroll();
    $(this).css('opacity', '1')
})
////车辆管理--点击查看详情
$('.view_detail').on('touchend', function () {
    stopTouchendPropagationAfterScroll();
    $('.car-manage').css('display', 'none')
    $('.car-manage-detail').css('display', 'block')
})
$('.manage-func-back').on('touchend',function () {
    stopTouchendPropagationAfterScroll();
    if(isToptabCarDetails===1){
       $(".home-car-carmanage").css("display",'block')
    }else{
        $('.car-manage').css('display', 'block')
    }
    $('.car-manage-detail').css('display', 'none')
})
/*************货主-我的**********/
$('.mine-body').find('.goods-account-info').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    var index = $(this).index();
    switch (index) {
        case 0: $('.goods-account-info').css('display', 'none');
            $('.goodsaccount-info_record').css('display', 'block');
            break;
        case 1: $('.goods-account-info').css('display', 'none');
            $('.goodsaccount-info_pwd').css('display', 'block');
            break;
    }
})
$('.account-func-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.goodsaccount-info-group').css('display', 'none');
    $('.goods-account-info').css('display', 'block')
})
$('.account-func-back1').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.caraccount-info-group').css('display', 'none');
    $('.car-account-info').css('display', 'block')
})
$('.goods-func-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.goods-fun-group').css('display', 'none');
    $('.home-goods-mine').css('display', 'block')
})
$('.goods-member-add').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.goods-member').css('display', 'none')
    $('.goods-member_add').css('display', 'block')
})
$('.goods-member-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.goods-member').css('display', 'block')
    $('.goods-member_add').css('display', 'none')
})
$(".info-ticket_add").on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.normal-info_ticket').css('display', 'none')
    $('.ticket_add').css('display', 'block')
})
$('.func-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.normal-info_ticket').css('display', 'block')
    $('.ticket_add').css('display', 'none')
})
/*货主-我的-数据统计*/
$('.statistic-func-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.goods-statistic-group').css('display', 'none');
    $('.goods-statistic').css('display', 'block')
})
$('.info-func-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.normal-info-group').css('display', 'none');
    $('.goods-normal-info').css('display', 'block')
})
$('.mine-body-receive').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.normal-info_raddr').css('display', 'none')
    $('.info_raddr_edit').css('display', 'block')
})
$('.raddr-func-back').on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    $('.normal-info_raddr').css('display', 'block')
    $('.info_raddr_edit').css('display', 'none')
})
/*清空处理*/
$('.deliver_reset').on('touchend',function () {
    stopTouchendPropagationAfterScroll()
    $('.deliver-mine-body').html('');
    $('.total').html('哎呀！内容被清空了。');
})
////我的--数据统计--开始时间选择
$('.start_time_picker1').click(function () {
    var now = new Date();
    weui.datePicker({
        start: 2018,      // 起始时间
        end: new Date(),       // 结束时间
        title: "开始时间",
        defaultValue: [now.getFullYear(),now.getMonth()+1,now.getDate()],
        onConfirm: function (result) {
            result[1].value=result[1].value<10?'0'+result[1].value:result[1].value;
            result[2].value=result[2].value<10?'0'+result[2].value:result[2].value;
            var selected_time=result[0].value+'-'+result[1].value+'-'+result[2].value;
            current_page.find('div .start_time').html(selected_time);
            current_page.find('div .start_time_get').val(selected_time);
        }
    });
})
///结束时间
$('.stop_time_picker1').click(function () {

    var now= new Date();
    weui.datePicker({
        start: 2018,
        end: new Date(),
        title: "结束时间",
        defaultValue:[now.getFullYear(),now.getMonth()+1,now.getDate()],
        onConfirm: function (result) {
            if(result[1].value<10)result[1].value='0'+result[1].value;
            if(result[2].value<10)result[2].value='0'+result[2].value;
            var end_time=result[0].value+'-'+result[1].value+'-'+result[2].value;
            current_page.find('div .end_time').html(end_time);
            current_page.find('div .end_time_get').val(end_time);
        }
    });
})
//货物类型
$('.option_type').click(function () {
    weui.picker([{
        label: '非金属矿石',
        value: 0
    }, {
        label: '机械、设备、电器',
        value: 1
    }, {
        label: '水泥',
        value: 2
    }, {
        label: '金属矿石',
        value: 3
    }, {
        label: '煤炭、及制品',
        value: 4
    },
        {
            label: '石油、天然气及制品',
            value: 5
        },
        {
            label: '矿建材料',
            value: 6
        },
        {
            label: '木材',
            value: 7
        },
        {
            label: '非金属矿石',
            value: 8
        },
        {
            label: '化肥及农药',
            value: 9
        },
        {
            label: '盐',
            value: 10
        }, {
            label: '粮食',
            value: 11
        }, {
            label: '轻工材料及制品',
            value: 12
        }, {
            label: '有色金属',
            value: 13
        }, {
            label: '轻工医药产品',
            value: 14
        }, {
            label: '现活农产品',
            value: 15
        }, {
            label: '冷藏冷冻货物',
            value: 16
        }, {
            label: '商品汽车',
            value: 17
        },
        {
            label: '其他',
            value: 18
        },
    ], {
        onChange: function (result){
        },
        onConfirm: function (result) {
            current_page.find('div .selected_type').html(result[0].label);
            current_page.find('div .selected_type_get').val(result[0].label);
        },
        title: '货物类型'
    });
});
/********************订单页***************/
$(".main div div").on('touchend', function () {
    stopTouchendPropagationAfterScroll()
    var index = $(this).index();
    $('.main div div').find('span').removeClass('order-item-on');
    $('.main div').find('.content-group').eq(index).find('span').addClass('order-item-on');
    $('.main div .order-group').removeClass('order-group-on');
    $('.main div').find('.order-group').eq(index).addClass('order-group-on');
    $(".resource-main-item").find(".resource_item_group").removeClass('order-group-on');
    $(".resource-main-item").find(".resource_item_group").eq(index).addClass('order-group-on');
})


$(function () {
    var $androidActionSheet = $('#androidActionsheet');
    var $androidMask = $androidActionSheet.find('.weui-mask');
    $("#showAndroidActionSheet").on('touchend', function () {
        $androidActionSheet.fadeIn(200);
        $androidMask.on('touchend', function () {
            $androidActionSheet.fadeOut(200);
        });
    });
});
/*******************/
/*司机认证*/
$(".is_mount").click(function () {
    if (this.value == 0) {
        $(".ismount").css('display', 'block')
    } else {
        $(".ismount").css('display', 'none')
    }

})