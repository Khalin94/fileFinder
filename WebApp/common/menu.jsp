<%
	String menu = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("menu"));
	String memType = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("memType"));
	
	if ("".equalsIgnoreCase(menu) || menu == null || menu.length() == 0) menu = "1";
	if ("".equalsIgnoreCase(memType) || memType == null || memType.length() == 0) memType = "1";
%>

<table border="0" cellpadding="0" cellspacing="0" width="190">
	<tr>
		<td width="190" align="center">
			<table border="0" cellspacing="0" cellpadding="0" border="1px solid #c0c0c0;">
				
				<!-- 첫번째 메뉴. 의원실 자료 요구 -->
				<% if ("1".equalsIgnoreCase(menu)) { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;<B>▷ 의원실 자료 요구</B></td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;□ 요구함 작성</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;□ 요구함 조회</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 작성 중 요구함</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 발송 완료 요구함</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 제출 완료 요구함</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 위원회 제출 신청함</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;□ 요구 목록 조회</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 제출 완료 요구 목록</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 미제출 요구 목록</td>
				</tr>
				<% } else { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;▷ 의원실 자료 요구</td>
				</tr>
				<tr>
					<td height="1" class="c1"></td>
				</tr>
				<% } %>
					
				<% if ("2".equalsIgnoreCase(menu)) { %>
				<!-- 두번째 메뉴. 위원회 자료 요구 -->
				<tr>
					<td width="190" height="23" class="e1">&nbsp;<B>▷ 위원회 자료 요구</B></td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;□ 요구함 작성</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;□ 요구함 조회</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 작성 중 요구함</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 접수 완료 요구함</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 발송 완료 요구함</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 제출 완료 요구함</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;□ 요구 목록 조회</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 제출 완료 요구 목록</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 미제출 요구 목록</td>
				</tr>
				<tr>
					<td height="23" class="f4">&nbsp;&nbsp;□ 기초 자료함</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 자료함 작성</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 자료함 조회</td>
				</tr>
				<tr>
					<td height="23" class="normal">&nbsp;&nbsp;&nbsp;&nbsp;- 자료 목록 조회</td>
				</tr>
				<% } else { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;▷ 위원회 자료 요구</td>
				</tr>
				<tr>
					<td height="1" class="c1"></td>
				</tr>
				<% } %>


				<!-- 세번째 메뉴. 공개 자료 목록 -->
				<tr>
					<td width="190" height="23" class="e1">&nbsp;▷ 공개 자료 목록</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>

				<!-- 네번째 메뉴. 정부 제출 자료함 -->
				<tr>
					<td width="190" height="23" class="e1">&nbsp;▷ 정부 제출 자료함</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>

				<!-- 다섯번째 메뉴. 위원회 일정 -->
				<% if ("2".equalsIgnoreCase(memType)) { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;▷ 위원회 일정</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>
				<% } %>

				<!-- 여섯번째 메뉴. 국회의원 및 직원 조회 -->
				<% if ("2".equalsIgnoreCase(memType)) { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;▷ 국회의원 및 직원 조회</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>
				<% } %>

				<!-- 일곱번째 메뉴. 기관 담당자 조회 -->
				<% if ("1".equalsIgnoreCase(memType)) { %>
				<tr>
					<td width="190" height="23" class="e1">&nbsp;▷ 기관 담당자 조회</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>
				<% } %>

				<!-- 여덟번째 메뉴. 바인더 요구 목록 -->
				<tr>
					<td width="190" height="23" class="e1">&nbsp;▷ 바인더 요구 목록</td>
				</tr>
				<tr>
					<td width="190" height="1" class="c1"></td>
				</tr>
			</table>
		</td>
	</tr>

	<!-- 관심 메뉴 바로가기 목록 -->
	<tr>
		<td width="190" style="padding-top:5px;padding-bottom:5px">
			<%@ include file="/common/myFavorite.jsp" %>
		</td>
	</tr>

	<!-- 메신져 다운로드 버튼 -->
	<tr>
		<td width="" height=""><button style="height:30px;width:190px;">Messenger Download</button>
		</td>
	</tr>

	<!-- 공백 여백 빈공간 짜투리 까투리~~ -->
	<tr>
		<td height="40"></td>
	</tr>

</table>