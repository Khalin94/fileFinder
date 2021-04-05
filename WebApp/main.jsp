<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
    session.setAttribute("clickno","22");
    session.setAttribute("clickid","0");
    session.setAttribute("oldclickid","999");
    
   System.out.println("=============================테스트페이지 : main.jsp ==================================");


	String strUserId = (String)session.getAttribute("USER_ID");
	String strMainOrganId = (String)session.getAttribute("ORGAN_ID");

	System.out.println(" Proxy-Client-IP : "+request.getHeader("Proxy-Client-IP"));
	System.out.println(" CHECKIP : "+session.getAttribute("CHECKIP"));

	// 2005-09-01 kogaeng ADD
	// 필요한 내용을 팝업 창으로 띄우기 위해서 아래 코드 추가
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;

	//이용자 정보 설정.
	try {         

		objUserInfo = new UserInfoDelegate(request);

	} catch(AppException objAppEx) {

		objMsgBean.setMsgType(nads.lib.message.MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode("SYS-00099");//세션 타임 아웃.
		response.sendRedirect("/login/Login4ReSession.jsp");
		return;

	}

	//코드 정보 설정.
	objCdinfo = CDInfoDelegate.getInstance();
	String strUserOrganID = objUserInfo.getOrganID();
	boolean isRequester = objUserInfo.isRequester();

	boolean blnOpenPopup = false;
	//if(objUserInfo.getIsMyCmtOrganID(strBudgetCode) && objUserInfo.isRequester()) blnOpenPopup = true;
	if(!objUserInfo.isRequester()) blnOpenPopup = true;


	// 요구자, 제출자 구분
	String REQ_SUBMT_FLAG = (String)session.getAttribute("REQ_SUBMT_FLAG").toString();	// 요구자 : 001, 제출자 : 002

	// 의원실, 위원회 구분
	String ORGAN_KIND = (String)session.getAttribute("ORGAN_KIND").toString();	// 의원실 : 003, 위원회 : 004
    String ORGAN_ID =  (String)session.getAttribute("ORGAN_ID").toString();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="JavaScript" type="text/JavaScript">
/*  부서 자료실, 국회전자문서시스템 Link  */
function fun_bottomhomepage(strUrl, strNm){
	window.open(strUrl, strNm);
}
/*  Link Function  */
function fun_bottommail(){
//	document.formName1.action = "http://naps.assembly.go.kr/egsign/main/gate.jsp";
//	document.formName1.action = "http://mail.assembly.go.kr/";
//	document.formName1.target = "xxx";
//	window.open('/egsign/blank.html', 'xxx', 'width=1000, height=800, resizable=yes, scrollbars=yes, toolbar=yes, status=yes, location=yes, menubar=yes, directories=yes');
	window.open('http://mail.assembly.go.kr/init.jsp', 'xxx', 'width=1000, height=800, resizable=yes, scrollbars=yes, toolbar=yes, status=yes, location=yes, menubar=yes, directories=yes');
//	formName1.submit();
}
</script> 
<script src='/js/activity.js'></script>
<script src='/js/leftmenu.js'></script>
<script language="JavaScript" type="text/JavaScript">
<!--
	function fun_chgcomm(strHighGubn, strLowGubn){

		var vaComm = document.form_main1.committee.value;

		var vaUrl = "/main.jsp?highgubn=" + strHighGubn + "&lowgubn=" + strLowGubn + "&comm=" + vaComm;

		window.location = vaUrl;

	}

	function fun_winopen(strUrl, strTitle){

		window.open(strUrl, strTitle, "status=yes, resizable=yes, menubar=yes,scrollbars=yes");

	}



	function fun_bottomhomepage(strUrl, strNm){

		window.open(strUrl, strNm);

	}


	function fun_bottomhomepage_pop(strUrl, strNm, width, height){

		//window.open(strUrl, strNm);

		var hWin=null;

		hWin = window.open(strUrl, strNm ,"toolbar=no,scrollbars=yes,left=1,top=1,width="+width+",height="+height+",resizable=no, screenX=0,screenY=0,top=100,left=100");

		hWin.focus();

	}

function showLayer(layername){
	MM_swapImage2();
	var obj;
	if ((obj=MM_findObj(layername))!=null) {
		obj.style.visibility='visible';
	}
}

function hideLayer(layername){
	MM_swapImageRestore2();
	var obj;
	if ((obj=MM_findObj(layername))!=null) {
		obj.style.visibility='hidden';
	}
}

function MM_swapImageRestore2(){
  var i,x,a=document.MM_srr;
  if(a==null || a=='null' || a=='undefinded') return;
  for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_swapImage2(){
  MM_swapImageRestore2();
   var i,j=0,x,a=MM_swapImage2.arguments; document.MM_srr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_srr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}

}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_showHideLayers() { //v6.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
    obj.visibility=v; }
}
//-->
</script>
</head>
<body>
<div id="wrap">
<!-- Main Top Include Start -->
    <jsp:include page="/inc/main_top.jsp" flush="true"/>
<!-- Main Top Include End -->
        <!-- <div class="mainBar"></div> -->
    <div id="conMain" style=" background:url(images2/main/main_img_bg.gif)  repeat-x left bottom; width:100%; height:500px; margin-bottom:0; margin-top:20px;" >
        <div id="container" style="  background:url(images2/main/main_img.jpg) no-repeat left bottom; height:500px; margin-bottom:0">

            <!-- 왼쪽 영역 배경있는 div  main_left.jsp -->
            <div id="leftMain">

				<!-- 왼쪽 메뉴 INCLUDE  START-->
				<%@ include file="main2/main_left.jsp" %>
				<!-- 왼쪽 메뉴 INCLUDE  END-->

            </div>
            <!--/ 왼쪽 영역 배경있는 div-->


            <!--오른쪽 영역 -->

            <div id="rightCon_main">
                <div id="mainMid"  onmouseover="MM_showHideLayers('main_dep2_1','','hide','main_dep2_2','','hide','main_dep2_3','','hide','main_dep2_4','','hide','main_dep2_5','','hide')">
                    <ul>

						<li  class="mBox01 ">
							<table width="420px;" align="center">
							<!-- Body 최근의정 자료함 메뉴 INCLUDE  START-->
							<%@ include file="main2/Board_Top.jsp" %>
							<!-- Body 최근의정 자료함 메뉴 INCLUDE  END-->
							</table>
						</li>


						<li  class="mBox02 mt10">
							<table width="420px;" align="center">
							<!-- Body 최근의정 자료목록 메뉴 INCLUDE  START-->
							<%@ include file="main2/Board_Bottom.jsp" %>
							<!-- Body 최근의정 자료목록 메뉴 INCLUDE  END-->
							</table>
						</li>


						<!-- Body Image Banner  Start-->
                        <li  class="mBox03 mt10">
                            <ul>
                                <%
                                System.out.println("isRequester"+isRequester);
                                System.out.println("ORGAN_ID"+ORGAN_ID);
                                %>
								<%
									// 요구자
									if("001".equals(REQ_SUBMT_FLAG)){
                                            // 의원실
                                            if("003".equals(ORGAN_KIND)) {
                                    %>
                                                <li>
                                                    <a href="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/w_quick_m_01_office.gif" width="102" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                                                </li>
                                    <%
                                            // 위원회
                                            } else {
                                    %>
                                                <li>
                                                    <a href="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/w_quick_m_01_special.gif" width="102" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                                                </li>
                                    <%
                                            }

                                    %>
                                                <li>
                                                    <a href="/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/w_quick_m_02.gif" width="97" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                                                </li>
                                                <li>
                                                    <a href="/infosearch/ISearch_Nads.jsp" onfocus="this.blur();"><img src="images2/main/w_quick_m_03.gif" width="95" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                                                </li>
                                                <li>
                                                    <a href="/activity/MyReqSubmitSearch.jsp" onfocus="this.blur();"><img src="images2/main/w_quick_m_04.gif" width="104" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                                                </li>
								<%
									// 제출자
									}else{
                                        if(ORGAN_ID.equals("GI00004739")&&isRequester==true){ //국회사무처
                                %>
                                                <li></li>
                                                <li><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_01.gif" width="131" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/infosearch/ISearch_Nads.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_02.gif" width="134" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/activity/MyReqSubmitSearch.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_03.gif" width="133" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                    <%  } else if (ORGAN_ID.equals("GI00004743")&&isRequester==true){   //도서관 %>
                                                <li></li>
                                                <li><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_04.gif" width="131" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/infosearch/ISearch_Nads.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_02.gif" width="134" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/activity/MyReqSubmitSearch.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_03.gif" width="133" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                    <%  } else if (ORGAN_ID.equals("GI00004746")&&isRequester==true){   //예산처 %>
                                                <li></li>
                                                <li><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_05.gif" width="131" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/infosearch/ISearch_Nads.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_02.gif" width="134" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/activity/MyReqSubmitSearch.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_03.gif" width="133" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                    <%  } else if ((ORGAN_ID.equals("GI00006569")||ORGAN_ID.equals("GI00006570"))&&isRequester==true){   //입법처 %>
                                                <li></li>
                                                <li><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_06.gif" width="131" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/infosearch/ISearch_Nads.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_02.gif" width="134" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/activity/MyReqSubmitSearch.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_03.gif" width="133" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                    <%//  } else if (isRequester==true){   //국회요구시 1개로 쓰려면 %>
                                                <!--li></li>
                                                <li><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_all.gif" width="131" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/infosearch/ISearch_Nads.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_02.gif" width="134" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                                                <li><a href="/activity/MyReqSubmitSearch.jsp" onfocus="this.blur();"><img src="images2/main/quick02_m_03.gif" width="133" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li-->
                                    <%  } else {%>
											<li>
												<a href="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/quick_m_01.gif" width="87" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
											</li>
											<li>
												<a href="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/quick_m_02.gif" width="79" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
											</li>
											<li>
												<a href="/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxList.jsp" onfocus="this.blur();"><img src="images2/main/quick_m_03.gif" width="67" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
											</li>
											<li>
												<a href="/infosearch/ISearch_Nads.jsp" onfocus="this.blur();"><img src="images2/main/quick_m_04.gif" width="76" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
											</li>
											<li>
												<a href="/activity/MyReqSubmitSearch.jsp" onfocus="this.blur();"><img src="images2/main/quick_m_05.gif" width="83" height="84" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
											</li>
                                    <%  }   %>
								<%  } %>


                            </ul>
                        </li>
						<!-- Body Image Banner  End-->

                    </ul>
                </div>
                <div id="mainRight">
                    <ul>
                        <!-- 새로운 자료요구 -->
                        <li class="rBox01">
							<!-- Body 새로운주요자료 메뉴 INCLUDE  START-->
							<%@ include file="/main2/Board_Notice.jsp" %>
							<!-- Body 새로운주요자료 메뉴 INCLUDE  END-->
                        </li>
                        <!-- /새로운 자료요구 -->
                        <!-- 배너 -->
                        <%if (!ORGAN_KIND.equals("006")){%>
                        <li class="rBox02 ">
                           <ul>
                           <li><a href="/activity/BizInfo.jsp" onfocus="this.blur();"><img src="/images2/main/banner_01.gif" width="104" height="29" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a></li>
                           <li><a href="javascript:fun_bottomhomepage('/common/ControlAccess.jsp','국회전자문서시스템')" onfocus="this.blur();"><img src="/images2/main/banner_02.gif" width="104" height="35" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a></li>
                           <li><a href="javascript:fun_bottommail()" onfocus="this.blur();"><img src="/images2/main/banner_03.gif" width="104" height="31"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
                           </ul>
                        </li>
                        <%} else {%>
                        <li class="rBox07 ">
                           <ul>
                           <li><a href="http://www.assembly.go.kr/renew10/anc/schedule/formation_vw.jsp" onfocus="this.blur();" target="_blank"><img src="images2/main/banner07.gif" width="191" height="94" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a></li>
                            <li></li>
                            <li></li>
                            </ul>
                        </li>
                        <%}%>
                        <!-- /배너 -->

                    </ul>
                </div>
            </div>
            <!--/오른쪽 영역 -->
        </div>
    </div>
</div>
<jsp:include page="/inc/main_footer.jsp" flush="true"/>
</div>
<form name="formName1" method="POST">
<input type="hidden" name="MAILGUBUN" value="GO">
</form>
<iframe frameborder="0" width="0" height="0" marginwidth="0" scrolling="yes" src="http://naps.assembly.go.kr/common/PopUp.jsp"></iframe>
</body>
</html>