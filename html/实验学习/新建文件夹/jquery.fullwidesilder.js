$(function(){
	var $setElm = $('.wideslider'),
	baseWidth = 920,
	baseHeight = 405,

	slideSpeed = 500,
	delayTime = 5000,
	easing = 'linear',

	autoPlay = '1', // notAutoPlay = '0'

	btnOpacity = 0.8,
	pnOpacity = 1;

	$setElm.each(function(){
		var targetObj = $(this);
		var widesliderWidth = baseWidth;
		var widesliderHeight = baseHeight;
		targetObj.children('ul').wrapAll('<div class="wideslider_base"><div class="wideslider_wrap"></div><div class="slider_prev"></div><div class="slider_next"></div></div>');

		var findBase = targetObj.find('.wideslider_base');
		var findWrap = targetObj.find('.wideslider_wrap');
		var findPrev = targetObj.find('.slider_prev');
		var findNext = targetObj.find('.slider_next');

		var baseListWidth = findWrap.children('ul').children('li').width();
		var baseListCount = findWrap.children('ul').children('li').length;

		var baseWrapWidth = (baseListWidth)*(baseListCount);

		var pagination = $('<div class="pagination"></div>');
		targetObj.append(pagination);
		var baseList = findWrap.children('ul').children('li');
		baseList.each(function(i){
			$(this).css({width:(baseWidth),height:(baseHeight)});
			pagination.append('<a href="javascript:void(0);" class="pn'+(i+1)+'"></a>');
		});

		var pnPoint = pagination.children('a');
		var pnFirst = pagination.children('a:first');
		var pnLast = pagination.children('a:last');
		var pnCount = pagination.children('a').length;
		pnPoint.css({opacity:(pnOpacity)}).hover(function(){
			$(this).stop().animate({opacity:'1'},300);
		}, function(){
			$(this).stop().animate({opacity:(pnOpacity)},300);
		});
		pnFirst.addClass('active');
		pnPoint.click(function(){
			if(autoPlay == '1'){clearInterval(wsSetTimer);}
			var setNum = pnPoint.index(this);
			var moveLeft = ((baseListWidth)*(setNum))+baseWrapWidth;
			findWrap.stop().animate({left: -(moveLeft)},slideSpeed,easing);
			pnPoint.removeClass('active');
			$(this).addClass('active');
			if(autoPlay == '1'){wsTimer();}
		});

		var makeClone = findWrap.children('ul');
		makeClone.clone().prependTo(findWrap);
		makeClone.clone().appendTo(findWrap);

		var allListWidth = findWrap.children('ul').children('li').width();
		var allListCount = findWrap.children('ul').children('li').length;

		var allLWrapWidth = (allListWidth)*(allListCount);
		var windowWidth = $(window).width();
		var posAdjust = ((windowWidth)-(baseWidth))/2;

		findBase.css({left:(posAdjust),width:(baseWidth),height:(baseHeight)});
		findPrev.css({left:-(baseWrapWidth),width:(baseWrapWidth),height:(baseHeight),opacity:(btnOpacity)});
		findNext.css({right:-(baseWrapWidth),width:(baseWrapWidth),height:(baseHeight),opacity:(btnOpacity)});
		$(window).bind('resize',function(){
			var windowWidth = $(window).width();
			var posAdjust = ((windowWidth)-(baseWidth))/2;
			findBase.css({left:(posAdjust)});
			findPrev.css({left:-(posAdjust),width:(posAdjust)});
			findNext.css({right:-(posAdjust),width:(posAdjust)});
		});

		findWrap.css({left:-(baseWrapWidth),width:(allLWrapWidth),height:(baseHeight)});
		findWrap.children('ul').css({width:(baseWrapWidth),height:(baseHeight)});

		var posResetNext = -(baseWrapWidth)*2;
		var posResetPrev = -(baseWrapWidth)+(baseWidth);

		if(autoPlay == '1'){wsTimer();}

		function wsTimer(){
			wsSetTimer = setInterval(function(){
				findNext.click();
			},delayTime);
		}
		findNext.click(function(){
			findWrap.not(':animated').each(function(){
				if(autoPlay == '1'){clearInterval(wsSetTimer);}
				var posLeft = parseInt($(findWrap).css('left'));
				var moveLeft = ((posLeft)-(baseWidth));
				findWrap.stop().animate({left:(moveLeft)},slideSpeed,easing,function(){
					var adjustLeft = parseInt($(findWrap).css('left'));
					if(adjustLeft == posResetNext){
						findWrap.css({left: -(baseWrapWidth)});
					}
				});
				var pnPointActive = pagination.children('a.active');
				pnPointActive.each(function(){
					var pnIndex = pnPoint.index(this);
					var listCount = pnIndex+1;
					if(pnCount == listCount){
						pnPointActive.removeClass('active');
						pnFirst.addClass('active');
					} else {
						pnPointActive.removeClass('active').next().addClass('active');
					}
				});
				if(autoPlay == '1'){wsTimer();}
			});
		}).hover(function(){
			$(this).stop().animate({opacity:((btnOpacity)-0.1)},100);
		}, function(){
			$(this).stop().animate({opacity:(btnOpacity)},100);
		});

		findPrev.click(function(){
			findWrap.not(':animated').each(function(){
				if(autoPlay == '1'){clearInterval(wsSetTimer);}
				var posLeft = parseInt($(findWrap).css('left'));
				var moveLeft = ((posLeft)+(baseWidth));
				findWrap.stop().animate({left:(moveLeft)},slideSpeed,easing,function(){
					var adjustLeft = parseInt($(findWrap).css('left'));
					var adjustLeftPrev = (posResetNext)+(baseWidth);
					if(adjustLeft == posResetPrev){
						findWrap.css({left: (adjustLeftPrev)});
					}
				});
				var pnPointActive = pagination.children('a.active');
				pnPointActive.each(function(){
					var pnIndex = pnPoint.index(this);
					var listCount = pnIndex+1;
					if(1 == listCount){
						pnPointActive.removeClass('active');
						pnLast.addClass('active');
					} else {
						pnPointActive.removeClass('active').prev().addClass('active');
					}
				});
				if(autoPlay == '1'){wsTimer();}
			});
		}).hover(function(){
			$(this).stop().animate({opacity:((btnOpacity)-0.1)},100);
		}, function(){
			$(this).stop().animate({opacity:(btnOpacity)},100);
		});
	});
});