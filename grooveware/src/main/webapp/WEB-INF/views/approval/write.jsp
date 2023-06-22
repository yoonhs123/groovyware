<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
.modal {
	display: none;
	position: fixed;
	z-index: 1;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
	background-color: #fefefe;
	margin: 15% 50%;
	padding: 20px;
	border: 1px solid #888;
	width: 30%;
	border-radius: 4px
}

.close {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
}

.close:hover, .close:focus {
	color: black;
	text-decoration: none;
	cursor: pointer;
}

.winnerList-container {
	display: grid;
	grid-gap: 5px;
	grid-template-columns: repeat(4, auto);
}

.winnerList-container .item {
	border: 1px solid #333;
	border-radius: 3px;
	padding: 5px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.right-contentbody2 {
	width: 85%;
	position: absolute;
	left: 17%;
	padding: 0% 8%;
}

.myForm .flexBox {
	display: flex;
	justify-content: space-between;
}
</style>
<script type="text/javascript">
	function check() {
		const f = document.myForm;
		let str;

		str = f.doc_name.value.trim();
		if (!str) {
			alert("제목을 입력하세요. ");
			f.subject.focus();
			return;
		}

		str = f.draft_deadline.value.trim();
		if (!str) {
			alert("처리기한을 입력하세요. ");
			f.draft_deadline.focus();
			return;
		}
		str = f.draft_content.value;
		if (!str || str === "<p><br></p>") {
			alert("내용을 입력하세요. ");
			f.content.focus();
			return false;
		}

		//let mode = "${mode}";
		/*
		if( (mode === "write") && (!f.selectFile.value) ) {
		    alert("이미지 파일을 추가 하세요. ");
		    f.selectFile.focus();
		    return;
		}
		 */

		f.action = "${pageContext.request.contextPath}/approval/${mode}";
		f.submit();
	}
</script>

<script>
function login() {
	location.href="${pageContext.request.contextPath}/member/login";
}

function ajaxFun(url, method, query, dataType, fn) {
	$.ajax({
		type:method,
		url:url,
		data:query,
		dataType:dataType,
		success:function(data) {
			fn(data);
		},
		beforeSend:function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", true);
		},
		error:function(jqXHR) {
			if(jqXHR.status === 403) {
				login();
				return false;
			} else if(jqXHR.status === 400) {
				alert("요청 처리가 실패했습니다.");
				return false;
			}
	    	
			console.log(jqXHR.responseText);
		}
	});
}

$(function(){
	$(".btnReceiverDialog").click(function(){
		$("#condition").val("userName");
		$("#keyword").val("");
		$(".dialog-receiver-list ul").empty();
		
		$("#myDialogModal").modal("show");
	});
	
	// 대화상자 - 받는사람 검색 버튼
	$(".btnReceiverFind").click(function(){
		let condition = $("#condition").val();
		let keyword = $("#keyword").val();
		if(! keyword) {
			$("#keyword").focus();
			return false;
		}
		
		let url = "${pageContext.request.contextPath}/note/listFriend"; 
		let query = "condition="+condition+"&keyword="+encodeURIComponent(keyword);
		
		const fn = function(data){
			$(".dialog-receiver-list ul").empty();
			searchListFriend(data);
		};
		ajaxFun(url, "get", query, "json", fn);
	});
	
	function searchListFriend(data) {
		let s;
		for(let i=0; i<data.listFriend.length; i++) {
			let userId = data.listFriend[i].userId;
			let userName = data.listFriend[i].userName;
			
			s = "<li><input type='checkbox' class='form-check-input' data-userId='"+userId+"' title='"+userId+"'> <span>"+userName+"</span></li>";
			$(".dialog-receiver-list ul").append(s);
		}
	}
	
	// 대화상자-받는 사람 추가 버튼
	$(".btnAdd").click(function(){
		let len1 = $(".dialog-receiver-list ul input[type=checkbox]:checked").length;
		let len2 = $("#forms-receiver-list input[name=receivers]").length;
		
		if(len1 === 0) {
			alert("추가할 사람을 먼저 선택하세요.");
			return false;			
		}
		
		if(len1 + len2 >= 5) {
			alert("받는사람은 최대 5명까지만 가능합니다.");
			return false;
		}
		
		var b, userId, userName, s;

		b = false;
		$(".dialog-receiver-list ul input[type=checkbox]:checked").each(function(){
			userId = $(this).attr("data-userId");
			userName = $(this).next("span").text();
			
			$("#forms-receiver-list input[name=receivers]").each(function(){
				if($(this).val() === userId) {
					b = true;
					return false;
				}
			});
			
			if(! b) {
				s = "<span class='receiver-user btn border px-1'>"+userName+" <i class='bi bi-trash' data-userId='"+userId+"'></i></span>";
				$(".forms-receiver-name").append(s);
				
				s = "<input type='hidden' name='receivers' value='"+userId+"'>";
				$("#forms-receiver-list").append(s);
			}
		});
		
		$("#myDialogModal").modal("hide");
	});
	
	$(".btnClose").click(function(){
		$("#myDialogModal").modal("hide");
	});
	
	$("body").on("click", ".bi-trash", function(){
		let userId = $(this).attr("data-userId");
		
		$(this).parent().remove();
		$("#forms-receiver-list input[name=receivers]").each(function(){
			let receiver = $(this).val();
			if(userId === receiver) {
				$(this).remove();
				return false;
			}
		});
		
	});

});
</script>

<script type="text/javascript">
	//모달 열기
	function openModal() {
		document.getElementById("myModal").style.display = "block";
	}

	// 모달 닫기
	function closeModal() {
		document.getElementById("myModal").style.display = "none";
	}

	// 사용자가 모달 외부를 클릭할 때 모달 닫기
	window.onclick = function(event) {
		var modal = document.getElementById("myModal");
		if (event.target === modal) {
			modal.style.display = "none";
		}
	};
</script>
<div class="left-side-bar">

	<ul>
		<li>
			<div class="box-wrapper">
				<div class="borderBox">
					<a>문서작성</a>
				</div>
				<div class="borderBox">
					<a>내문서</a>
				</div>
			</div>
		</li>

		<li><a href="#">문서함</a> <a href="#">&nbsp;내 문서</a> <a href="#">&nbsp;부서
				문서</a> <a href="#">&nbsp;임시보관 문서</a> <a href="#">&nbsp;중요 문서</a>
		<li>

			<hr>
		<li><a href="#">결재함</a> <a href="#">&nbsp;대기</a> <a href="#">&nbsp;진행중</a>
			<a href="#">&nbsp;보류</a> <a href="#">&nbsp;반려</a> <a href="#">&nbsp;완료</a>
		<li>
	</ul>
</div>

<div class="left-menu" style="">

	<ul>
		<li><a href="#">즐겨찾기</a> <a
			href="${pageContext.request.contextPath}/pro/approval/write.jsp"><i
				class="fa-regular fa-file-lines icon"></i>기안서</a> <a
			href="${pageContext.request.contextPath}/pro/approval/write.jsp"><i
				class="fa-regular fa-file-lines icon"></i>연차휴가</a>
		<li>

			<hr>
		<li><a href="#">일반 결재 문서</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>계약확인서</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>공문서</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>기안서</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>사유서</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>시말서</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>업무보고서</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>업무협조전</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>위임장</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>인장요청서</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>증명보고서</a> <a href="#"><i
				class="fa-regular fa-file-lines icon"></i>인사발령</a>
		<li>
	</ul>
</div>


<div class="right-contentbody">
	<div class="right-contentbody2">
		<form name="myForm" method="post" class="myForm"
			enctype="multipart/form-data">
			<div class="board1">
				<div class="title_container">
					<table class="table" style="margin-bottom: 20px;">
						<tr>
							<td class="title2" width="12%">
								<h2>
									<span>|</span> 기안서
								</h2>
							</td>
							<td class="title">
								<button type="button" class="btn">취소</button>
								<button type="button" class="btn"
									onclick="submitContents(this.form);">임시저장</button>
								<button type="button" class="btn" onclick=" ">제출</button>
							</td>
						</tr>
					</table>
				</div>
				<div class="line_container">
					<div class="table" style="margin-bottom: 15px;">
						<div>
							<div class="title" style="float: left; width: 50%;">
								<span>결재라인</span>
							</div>
							<div class="title">
								<span> 공유자</span>
							</div>
						</div>
						<div style="width: 50%; float: left;">
							<div class="img_container ">
								<img class="" src="/test.jpg">
							</div>
							<div class="img_container3 ">
								<i class="fa-solid fa-chevron-right"></i>
							</div>
							<div class="img_container ">
								<img class="" src="test.jpg">
							</div>
							<div class="img_container3 ">
								<i class="fa-solid fa-chevron-right"></i>
							</div>
							<div class=" img_container">
								<img class="" src="test.jpg">
							</div>
							<!-- 모달을 띄울 추가 버튼 -->
							<button type="button" class="btn" onclick="openModal() "
								style="margin-top: 5px;">추가 버튼</button>
						</div>

						<div style="">
							<div class="img_container">
								<img class="" src="test.jpg">
							</div>
							<!-- 플러스 버튼 후 결제라인 설정 팝업 -->
						</div>


						<div style="width: 50%; float: left;">
							<div class="text_box3">김민교</div>
							<div class="text_box4">&nbsp;</div>
							<div class="text_box3">남기현</div>
							<div class="text_box4">&nbsp;</div>
							<div class="text_box3">최고관리자</div>

							<!-- 플러스 버튼 후 결제라인 설정 팝업 -->
						</div>

						<div>
							<div class="text_box3" style="margin-bottom: 10px;">최민정</div>
							<!-- 플러스 버튼 후 결제라인 설정 팝업 -->
						</div>
					</div>
				</div>
			</div>
			<div class="board3">
				<div class="line_container2">
					<div>
						<div>
							<div>
								<label>제목 </label>
							</div>
							<p class="ap_pBox">
								<input type="text" name="doc_name" class="form-control1"
									style="width: 100%;">
							</p>
						</div>

						<div>
							<div class="flexBox">
								<div class="leftBox" style="margin-right: 55px">
									<label>기안구분 </label>
								</div>
								<div class="leftBox">
									<label>긴급여부 </label>
								</div>
							</div>
							<div class="flexBox">

								<div class="leftBox">
									<p class="ap_pBox">
										<label for="draft1"> <input type="radio"
											name="draft_category" id="draft1" value="0" checked />품의서
										</label> <label for="draft2"> <input type="radio"
											name="draft_category" id="draft2" value="1" />기안서
										</label>
									</p>
								</div>
								<div class="leftBox">
									<p class="ap_pBox">
										<label for="draft1"> <input type="radio" name="urgent"
											id="draft1" value="0" checked />일반 </label> 
										<label for="draft2"> <input type="radio"
											name="urgent" id="draft2" value="1" />긴급</label>
									</p>
								</div>
							</div>

							<div class="flexBox">
								<div class="leftBox">
									<label>기안일자 </label>
								</div>
								<div class="leftBox">
									<label>처리기한 </label>
								</div>
							</div>
							<div class="flexBox ap_pBox">

								<div class="leftBox">
									<p>
										<input type="date" name="draft_date" class="form-control1"
											readonly="readonly" value="${currentDate}" />
									</p>
								</div>
								<div class="leftBox">
									<input type="date" name="draft_deadline" class="form-control1" />
								</div>
								
							</div>

							<div class="flexBox">
								<div class="leftBox">
									<label>기안부서 </label>
								</div>
								<div class="leftBox">
									<label>기안담당 </label>
								</div>
							</div>
							<div class="flexBox ap_pBox">
								<div class="leftBox">
									<input type="text" name="" class="form-control1"
										readonly="readonly" value="${sessionScope.member.dept_name}" />
								</div>
								<div class="leftBox">
									<input type="text" name="" class="form-control1"
										readonly="readonly" value="${sessionScope.member.emp_name}" />
								</div>
							</div>

						</div>
						<div class="leftBox">
							<label>내용 </label>
						</div>
						<textarea name="draft_content" id="ir1" class="form-control"
							style="width: 93%; padding: 7px 5px; height: 400px;">${dto.content}</textarea>
					</div>
				</div>
			</div>
			<div class="board1">
				<div class="file_container">
					<div>
						<div class="title3">
							<span> 첨부파일</span>
						</div>
					</div>
					<div class="file_container2">
						<div class="table table-border table-form">
							<div>
								<input type="file" name="selectFile" multiple="multiple"
									class="form-control1">
							</div>
							<div>
								<div></div>
								<div>
									<div class="img-box">
										<c:forEach var="vo" items="${listFile}">
											<img src="${pageContext.request.contextPath} "
												onclick="deleteFile('${vo.fileNum}');">
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="board4 confirm">
				<button type="button" class="btn2"
					onclick="location.href='${pageContext.request.contextPath}/approval/list';">취소</button>
				<button type="button" class="btn2"
					onclick="submitContents(this.form);">임시저장</button>
				<button type="button" class="btn2">제출</button>
			<c:if test="${mode=='update'}">
				<input type="hidden" name="num" value="${dto.doc_no}">
				<input type="hidden" name="page" value="${page}">
			</c:if>
			</div>
		</form>
	</div>

</div>


<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/vendor/se2/js/service/HuskyEZCreator.js"
	charset="utf-8"></script>
<script type="text/javascript">
	var oEditors = [];
	nhn.husky.EZCreator
			.createInIFrame({
				oAppRef : oEditors,
				elPlaceHolder : "ir1",
				sSkinURI : "${pageContext.request.contextPath}/resources/vendor/se2/SmartEditor2Skin.html",
				fCreator : "createSEditor2"
			});

	function submitContents(elClickedObj) {
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
		try {
			if (!check()) {
				return;
			}

			elClickedObj.submit();

		} catch (e) {
		}
	}

	function setDefaultFont() {
		var sDefaultFont = '돋움';
		var nFontSize = 12;
		oEditors.getById["ir1"].setDefaultFont(sDefaultFont, nFontSize);
	}
</script>


<!-- 모달 -->
<div id="myModal" class="modal">
	<div class="modal-content">
		<form name="nameForm" method="post">
			<div style="border-bottom: 1px solid #ced4da; padding-bottom: 10px;">
				<button type="button" class="btn btnClose" style="float: right;">
					<span class="close">&times;</span>
				</button>
				<h3 style="margin-bottom: 20px;">이름 검색</h3>
				<input type="text" name="keyword" id="keyword" placeholder="이름을 입력하세요"
					class="form-control" style="height: 26px;">
				<button type="submit" class="btn btnReceiverFind">검색</button>
			</div>
			<table class="table table-border table-form">
				<tbody>
					<tr>
						<td height="50%">
							<div style="height: 150px; border: 1px solid black;border-radius: 4px"></div>
						</td>
					</tr>
					<tr>
						<td align="right">
							<input type="hidden" name="num" value="${dto.num}"> 
							<input type="hidden" name="page" value="${page}">
							<button type="button" class="btn">추가</button>
							<button type="button" class="btn btnClose">닫기</button></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</div>

