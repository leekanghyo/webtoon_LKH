var isCheck = false;
var use;
var isChange = false;
var pw = "";
var pwuse;
$(document).ready(function() {
	
	/* id 입력란의 변화가 있을 경우 실행 : 중복 체크 실행 여부를 false */
	$("input[name=id]").keydown(function() {
		isChange = true;
		use = "";
		$('input[id=idmessage]').css("display", "none");
		isCheck = false;
	});
	//--------프로필 체인지
	
});

function writeSave() {
	/* ID 관련 유효성 검사 */
	if ($("input[name=id]").val() == "") {
		alert("ID 누락");
		isChange = false;
		$("input[name=id]").focus();
		return false;
	}

	if (use == "impossible") {
		alert("이미 사용중인 ID입니다.");
		return false;
	}
	
	if (isCheck == false || isChange == true) {
		alert("ID 중복 체크가 필요합니다.");
		return false;
	}
	
	if ($("input[name=name]").val() == "") {
		alert("닉네임을 입력하세요. 작가는 웹툰 투고 시, 메인에 표시합니다.");
		return false;
	}

/*	if ($("input[name=wtmtype]").val() == "writer") {
		
			// 사이즈체크
			var maxSize = 5 * 1024 * 1024 // 30MB
			var fileSize = 0;

			// 브라우저 확인
			var browser = navigator.appName;

			// 익스플로러일 경우
			if (browser == "Microsoft Internet Explorer") {
				var oas = new ActiveXObject("Scripting.FileSystemObject");
				fileSize = oas.getFile($("input[name=memberimg]").val()).size;
			}
			// 익스플로러가 아닐경우
			else {
				fileSize = $("input[name=memberimg]").files[0].size;
			}

			alert("파일사이즈 : " + fileSize + ", 최대파일사이즈 : 5MB");

			if (fileSize > maxSize) {
				alert("첨부파일 사이즈는 5MB 이내로 등록 가능합니다.    ");
				return;
			}
		

	}
*/
	/* PW 관련 유효성 검사 */
	if ($("input[name=passwd]").val() == "") {
		alert("PW 누락");
		isChange = false;
		$("input[name=passwd]").focus();
		return false;
	}
	if (pwuse == "formaterror") {
		alert("PW형식이 잘못되었습니다.");
		return false;
	}

	if ($("input[name=repasswd]").val() == "") {
		alert("PW확인 누락");
		isChange = false;
		$("input[name=repasswd]").focus();
		return false;
	}
}
function accountcheck() {
	isCheck = true;
	isChange = false;
	
	$.ajax({
		url : "id_checkPro.jsp",
		data : ({
			userId : $("input[name=id]").val()
		}),
		success : function(data) {
			if ($("input[name=id]").val() == "") {
				$('span[id=idmessage]').html(
						"<font color='red'>ID 입력 누락</font>");
				$('span[id=idmessage]').show();
			} else if (jQuery.trim(data) == "Yes") {
				$('span[id=idmessage]').html(
						"<font color='blue'>사용 가능</font>");
				$('span[id=idmessage]').show();
				use = "possible";
			} else {
				$('span[id=idmessage]').html(
						"<font color='red'>사용 불가</font>");
				$('span[id=idmessage]').show();
				use = "impossible";
					}
		}
	});
}

function pwcheck() { // 패스워드 양식 체크

	var pw = $('input[name=passwd]').val();
	var regexp = /^[A-Za-z0-9]{3,5}$/; // 영 대소문자 숫자 조합 12~15자

	if (!regexp.test(pw)) {
		alert("Pattern of Violations");
		pwuse = "formaterror";
		return false;
	}

	var chk_num = pw.search(/[0-9]/);
	var chk_eng = pw.search(/[a-z]/i); // i : 대소문자 구분X

	if (chk_num < 0 || chk_eng < 0) {
		alert("Pattern of Violations Please input [A~a, 1~9]");
		pwuse = "formaterror";
		return false;
	} else {
		pwuse = "";
	}
}

function cleaerpwmsg() {

	$('input[id=pwmessage]').css("display", "none");
}

function passwd_keyUp() {

	pws = $('input[name=passwd]').val();
	pwr = $('input[name=repasswd]').val();

	if (pws == "") {
		return;
	}

	if (pws == pwr) {
		$('span[id=pwmessage]').html("<font color='blue'>PW Matched</font>");
		$('span[id=pwmessage]').show();
	} else {
		$('span[id=pwmessage]').html("<font color='red'>PW Mismatched</font>");
		$('span[id=pwmessage]').show();
	}
}