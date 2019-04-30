window.onload = function() {
	  var divs = document.getElementsByClassName("thumbnail-frame1"); //div 클래스 획득
	  for (var i = 0; i < divs.length; ++i) {
	    var div = divs[i];
	    
	    var divAspect = div.offsetHeight / div.offsetWidth;  //종횡비
	    div.style.overflow = 'hidden'; //div영역을 넘어가는 부분은 숨긴다.(잘라냄 효과)
	    
	    var img = div.querySelector('img'); //div안에 있는 img 태그들을 담는다.
	    var imgAspect = img.height / img.width; //img 종횡비

	    if (imgAspect <= divAspect) { // img 종횡비가 div과 같거나 더 작을 경우(즉 더 납작할 경우)
	      // 이미지가 div보다 납작한 경우 세로를 div에 맞추고 가로는 잘라낸다
	      
		      //가운데 정렬
		      var imgWidthActual = div.offsetHeight / imgAspect; //*img가 갖춰야할 가로 크기
		      var imgWidthToBe = div.offsetHeight / divAspect;
		      //var marginLeft = -Math.round((imgWidthActual - imgWidthToBe) / 2);// div 가로 값과 img 가로의 평균값...
		      img.style.cssText = 'width: auto; height: 100%; margin-left: '+ 0 + 'px;'
		    } else {
		      // 이미지가 div보다 길쭉한 경우 가로를 div에 맞추고 세로를 잘라낸다
		      img.style.cssText = 'width: 100%; height: auto; margin-left:0px;';
		    }
		  }

	  var divs = document.getElementsByClassName("thumbnail-frame2"); //div 클래스 획득
	  for (var i = 0; i < divs.length; ++i) {
		  var div = divs[i];
		  
		  var divAspect = div.offsetHeight / div.offsetWidth;  //종횡비
		  div.style.overflow = 'hidden'; //div영역을 넘어가는 부분은 숨긴다.(잘라냄 효과)
		  
		  var img = div.querySelector('img'); //div안에 있는 img 태그들을 담는다.
		  var imgAspect = img.height / img.width; //img 종횡비
		  
		  if (imgAspect <= divAspect) { // img 종횡비가 div과 같거나 더 작을 경우(즉 더 납작할 경우)
			  // 이미지가 div보다 납작한 경우 세로를 div에 맞추고 가로는 잘라낸다
			  
			  //가운데 정렬
			  var imgWidthActual = div.offsetHeight / imgAspect; //*img가 갖춰야할 가로 크기
			  var imgWidthToBe = div.offsetHeight / divAspect;
			  //var marginLeft = -Math.round((imgWidthActual - imgWidthToBe) / 2);// div 가로 값과 img 가로의 평균값...
			  img.style.cssText = 'width: auto; height: 100%; margin-left: '+ 0 + 'px;'
		  } else {
			  // 이미지가 div보다 길쭉한 경우 가로를 div에 맞추고 세로를 잘라낸다
			  img.style.cssText = 'width: 100%; height: auto; margin-left:0px;';
		  }
	  }

	  
	  
	  
	  var divs = document.getElementsByClassName("thumbnail-frame-toon"); //div 클래스 획득
	  for (var i = 0; i < divs.length; ++i) {
		  var div = divs[i];
		  
		  var divAspect = div.offsetHeight / div.offsetWidth;  //종횡비
		  div.style.overflow = 'hidden'; //div영역을 넘어가는 부분은 숨긴다.(잘라냄 효과)
		  
		  var img = div.querySelector('img'); //div안에 있는 img 태그들을 담는다.
		  var imgAspect = img.height / img.width; //img 종횡비
		  
		  if (imgAspect <= divAspect) { // img 종횡비가 div과 같거나 더 작을 경우(즉 더 납작할 경우)
			  // 이미지가 div보다 납작한 경우 세로를 div에 맞추고 가로는 잘라낸다
			 
			  //가운데 정렬
			  var imgWidthActual = div.offsetHeight / imgAspect; //*img가 갖춰야할 가로 크기
			  var imgWidthToBe = div.offsetHeight / divAspect;
			  var marginLeft = -Math.round((imgWidthActual - imgWidthToBe) / 2);// div 가로 값과 img 가로의 평균값...
			  img.style.cssText = 'width: auto; height: 100%; margin-left: '+ marginLeft + 'px; position: relative;'
		  } else {
			  // 이미지가 div보다 길쭉한 경우 가로를 div에 맞추고 세로를 잘라낸다
			  img.style.cssText = 'width: 100%; height: auto; margin-left:0px; position: relative;';
		  }
	  }
	}