<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%><%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%><script type="text/JavaScript">	function getParams() {		$.ajax({		    type : 'GET',		    url : 'getReports',			    data: $('#thisForm').serialize(),		    success : function(result) {				$('#office').html(result);				},				error : function(e) {					alert('error: ' + e.text());				}                        		});	}     $(function() {	    $( "#searchCityString" ).datepicker({		'format': 'm/d/yyyy',		'autoclose': true    	    });	});     $(function() {	    $( "#searchStateString" ).datepicker({		'format': 'm/d/yyyy',		'autoclose': true    	    });	});	function getParams2() {		var form = document.getElementById("thisForm");		form.action = 'getReports';		form.method = 'POST';					form.submit();					}	function runReport(p) {		var form = document.getElementById("thisForm");			form.action = 'runReportsPaged?page='+p;		form.method = 'POST';					form.submit();	}	function validate(form) {		return true;	}	function exportReportData() {		   var container = $('#exportRpt');	        $.ajax({	            type : 'POST',	            url : 'exportReportData',	            data: $('#thisForm').serialize(),	            	            success : function(result) {         		//var outStr = 'Click <a href="' + result + '"><font color="blue">here</font></a> to download the report data file';         		//container.html(outStr);         		var res = '<a href="' + result + '"> Report File</a>';			popup(res, 0);	            },				error : function(e) {					alert('error: ' + e.text());				}                        	        });	}		function runSort(p, sortBy) {		var form = document.getElementById("thisForm");		var oldCol = form.elements["sortColumn"].value;		var oldOrd = form.elements["sortOrder"].value;				if (sortBy == oldCol) {					if (oldOrd == "asc") {				form.elements["sortOrder"].value = 'desc';			} else {				form.elements["sortOrder"].value = 'asc';			}		} else {			form.elements["sortColumn"].value = sortBy;			form.elements["sortOrder"].value = 'asc';		}		form.action = 'runReportsPaged?page='+p;		form.method = 'POST';					form.submit();		}</script><!-- // header --><!-- content wrapper --><div class="content_wrapper">	<form:form id="thisForm" method="post" action="runReports"		commandName="ltUser">	<form:hidden path="sortColumn"/>	<form:hidden path="sortOrder"/>		<!-- left side navigation -->		<ul class="ul_left_nav">			<c:if test = '${ltUser.user.roleActions[0].roleType == "Entity"}'>  					<li class="si_dashboard"><a href="dashboardEntity">Dashboard</a></li>				<li class="si_custom_msg"><a href="customMessageEntity">Create Custom Message</a></li>				<li class="si_confirmation"><a href="confirmationMessage">Confirmation Message</a></li>						<li class="si_send_msg"><a href="sendMessage">Send Message</a></li>				<li class="si_sendafriend"><a href="sendAFriend">Send a Friend</a></li>				<li class="si_reports selected"><a href="getReports">Reports</a></li>     						<li class="si_mobile_profile"><a href="getProfile">My Mobile Profile</a></li>				</c:if>			<c:if test = '${ltUser.user.roleActions[0].roleType == "Office"}'>				<li class="si_dashboard"><a href="dashboardOffice">Dashboard</a></li>					<li class="si_custom_msg"><a href="customMessage">Create Custom Message</a></li>				<li class="si_confirmation"><a href="confirmationMessage">Confirmation Message</a></li>					<li class="si_reports selected"><a href="getReports">Reports</a></li>	      					<li class="si_mobile_profile"><a href="getProfile">My Mobile Profile</a></li>				</c:if>   			<c:if test = '${ltUser.user.roleActions[0].roleType == "Corporate"}'>				<li class="si_dashboard"><a href="dashboardCorp">Dashboard</a></li>					<li class="si_custom_msg_approve"><a href="customMessageCorp">Approve Custom Messages</a></li>   				<li class="si_confirmation"><a href="confirmationMessage">Confirmation Message</a></li>									<li class="si_send_msg"><a href="sendMessage">Send Message</a></li>	      					<li class="si_search"><a href="corpSearch">Search</a></li>					<li class="si_reports selected"><a href="getReports">Reports</a></li>	      				</c:if> 			<c:if test = '${ltUser.user.roleActions[0].roleType == "AD"}'>  					<li class="si_dashboard"><a href="dashboardAD">Dashboard</a></li>				<li class="si_confirmation"><a href="confirmationMessage">Confirmation Message</a></li>						<li class="si_reports selected"><a href="getReports">Reports</a></li>					<li class="si_mobile_profile"><a href="getProfile">My Mobile Profile</a></li>				</c:if>								<li class="si_toolbox"><a href="cmtoolbox">Convergent Toolbox</a></li>		</ul>		<!-- // left side navigation -->		<!-- content area -->		<div class="content" id="id_content_06">			<div class="nav_pointer pos_01"></div>			<!-- subheader -->			<div class="subheader clearfix">				<h1>Reports</h1>				<p>				<c:if test='${ltUser.user.roleActions[0].roleType == "Office"}'>									Office Id: <c:out value="${sites[0].customField2}" />				</c:if>				<c:if test='${ltUser.user.roleActions[0].roleType == "Entity"}'>				        				Entity Id: <c:out value="${sites[0].customField1}"/>				</c:if>					</p>			</div>			<!-- // subheader -->			<div class="inner_box">				<!-- box -->				<div class="box box_grey_title box_report">					<!-- title -->					<div class="box_title mb9">						<h2>View Report</h2>					</div>					<!-- // title -->					<!-- wide_column -->          				<div class="wide_column_wrapper report_container" id="id_report_scroll_entity">						<div class="description" id="id_report_01">							<c:if test="${ltUser.reportRows == null}">								<p>Generate reports using the tools on the right.</p>							</c:if>							<c:if test="${fn:length(ltUser.reportRows) <= 0}">								<p>No data found.</p>							</c:if>														<c:if test="${fn:length(ltUser.reportRows) > 0}">								<c:if test="${ltUser.summaryRow != null}">									<br/><c:forEach var="entry" items="${ltUser.summaryRow}">									    <b>${entry.key}:</b> ${entry.value}									</c:forEach>									</c:if>								<br/>															<c:set var="colCnt"									value="${fn:length(ltUser.reportColumnHeaders)}" />								<c:set var="colWidth" value="${100/colCnt}%"/>																<table class="table-2 text-left">									<tr class="row0">									<c:forEach var="reportColumn"										items="${ltUser.reportColumnHeaders}" varStatus="loopStatus1">										<td class="col-1" width="${colWidth}"><b><a											href="javascript:runSort(${currentPage}, ${loopStatus1.count})"><c:out													value="${reportColumn}" /></b></a></td>									</c:forEach>									</tr>									<c:forEach var="reportDataRow" items="${ltUser.reportRows}" varStatus="loopStatus">										<c:set var="rowidx" value="${loopStatus.index % 2}" />										<tr class="row${rowidx}">											<c:forEach begin="0" end="${colCnt-1}" varStatus="i">												<c:if test="${i.index == 0}">													<td class="col-1" width="${colWidth}"><c:out value="${reportDataRow.column1}" /></td>												</c:if>												<c:if test="${i.index == 1}">													<td class="col-1" width="${colWidth}"><c:out value="${reportDataRow.column2}" /></td>												</c:if>												<c:if test="${i.index == 2}">													<td class="col-1" width="${colWidth}"><c:out value="${reportDataRow.column3}" /></td>												</c:if>												<c:if test="${i.index == 3}">													<td class="col-1" width="${colWidth}"><c:out value="${reportDataRow.column4}" /></td>												</c:if>												<c:if test="${i.index == 4}">													<td class="col-1" width="${colWidth}"><c:out value="${reportDataRow.column5}" /></td>												</c:if>												<c:if test="${i.index == 5}">													<td class="col-1" width="${colWidth}"><c:out value="${reportDataRow.column6}" /></td>												</c:if>											</c:forEach>										</tr>									</c:forEach>								</table>							</c:if>						</div>						</div>						<c:if test="${fn:length(ltUser.reportRows) > 0}">							<br />							<%--For displaying Page numbers. The when condition does not display a link for the current page--%>							<table border="0" class="table-2 ">								<tr>									<%--For displaying Previous link except for the 1st page --%>									<c:if test="${currentPage != 1}">										<td><a href="#"											onclick="return runReport(${currentPage-1})"><strong>Previous</strong></a></td>									</c:if>									<c:forEach begin="${currentPageStart}" end="${currentPageEnd}" var="i">										<c:choose>											<c:when test="${currentPage eq i}">												<td><strong>${i}</strong></td>											</c:when>											<c:otherwise>												<td><a href="#" onclick="return runReport(${i})">${i}</a></td>												</c:otherwise>										</c:choose>									</c:forEach>									<%--For displaying Next link --%>									<c:if test="${currentPage lt noOfPages}">										<td><a href="#"											onclick="return runReport(${currentPage+1})"><strong>Next</strong></a></td>									</c:if>								</tr>							</table>						</c:if>					</div>					<!-- // wide_column -->				<!-- // box -->				<!-- convert icons wrapper -->				<div class="c_icons_wrapper">					<!-- 					<a href="#" class="lnk_convert_ico ico_xls">XLS</a> 					<a href="#"						class="lnk_convert_ico ico_pdf">PDF</a> <a href="#"						class="lnk_convert_ico ico_prn">Print</a>					-->				</div>							<!-- // convert icons wrapper -->			</div>		</div>		<!-- // content area -->		<!-- sidebar -->		<div class="sidebar" id="id_sidebar_06">			<div class="inner">				<!-- title -->				<div class="sb_title">				     <h2 class="Mobile Marketing">REPORTS</h2>				</div>								     <div class="sb_box_01 sb_box_h01">				     					<div class="select_wrapper_n01">						<form:select path="searchKeywordString"							onchange="return getParams();" class="select_send_notification_01">							<form:option value="">Select a Report</form:option>							<form:options items="${reports}" itemValue="reportId"								itemLabel="name" />						</form:select>					</div>					<c:forEach var="report" items="${reports}" varStatus="loopStatus1">						<c:if test="${ltUser.searchKeywordString == report.reportId}">							<form:hidden path="reports[${loopStatus1.index}].reportId" />							<form:hidden path="reports[${loopStatus1.index}].reportType" />							<div class="form_wrapper_sn">							<c:forEach var="rp" items="${report.params}" varStatus="loopStatus">								<form:hidden									path="reports[${loopStatus1.index}].params[${loopStatus.index}].paramName" />									<div class="fwsn_field">									<label><c:out value="${rp.paramLabel}" /></label>									<c:choose>											<c:when test='${rp.paramName == "userIds"}'>												<form:select													path="reports[${loopStatus1.index}].params[${loopStatus.index}].paramValue">													<form:options items="${ltUser.sites}" itemValue="userId"														itemLabel="keyword" />												</form:select>											</c:when>											<c:when test='${rp.paramName == "campaignId"}'>												<form:select													path="reports[${loopStatus1.index}].params[${loopStatus.index}].paramValue">													<form:options items="${ltUser.reportData}" itemValue="field1"														itemLabel="field2" />												</form:select>											</c:when>																									<c:otherwise>												<form:input													path="reports[${loopStatus1.index}].params[${loopStatus.index}].paramValue" />											</c:otherwise>										</c:choose>									</div>							</c:forEach>							<div class="fwsn_field">								<label>Start Date</label>								<form:input path="searchCityString" class="input_date_01" />							</div>							<div class="fwsn_field">								<label>End Date</label>								<form:input path="searchStateString" class="input_date_01" />							</div>						   </div>						   							<div class="button_wrapper_02">								<center>									<input type="button" onclick="return runReport(1)"										class="btn_green btn_report_01" value="Run Report">								</center>							</div>														<br/>							<div class="buttons-1" id="exportRpt">								Export your report data by clicking on this icon								<a href="#" class="lnk_convert_ico ico_xls" onclick="exportReportData();"></a>											</div>															</c:if>					</c:forEach>				</div>				<!-- // sidebar box type 1 -->			</div>		</div>		<!-- // sidebar -->		<div class="floatfix"></div>	</form:form></div></div><!-- // content wrapper -->