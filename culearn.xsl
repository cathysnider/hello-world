<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes" />
	<!-- by Cathy Snider, Web Communications, CU-Boulder -->
    <!-- updates by Lou Ordica March 2017 -->
	<!-- another comment here -->
    
	<xsl:param name="message"></xsl:param>
	<xsl:param name="coursetype"></xsl:param>
	<xsl:template match="root">
		<html>
<head>
<title>Request Changes to Desire2Learn (D2L) Course FIXED</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
<script type="text/javascript" language="javascript">

$(function(){           
		$('a.backButton').click(function(){ 
		 
			var envURL = document.URL;
			
			//Default to Prod
			var target = "https://portal.prod.cu.edu/psp/epprod/UCB2/ENTP/h/?tab=CU_FACULTY";
			
			/**
			Dev URLS
			https://iepdev.dev.cu.edu/psp/iepdev/UCB2/ENTP/h/?tab=CU_FACULTY
			https://ieptst.qa.cu.edu/psp/ieptst/UCB2/ENTP/h/?tab=CU_FACULTY
			https://iepstg.qa.cu.edu/psp/iepstg/UCB2/ENTP/h/?tab=CU_FACULTY
			https://portal.prod.cu.edu/psp/epprod/UCB2/ENTP/h/?tab=CU_FACULTY
			*/
			
			if (envURL.indexOf("icsdev") > -1) {
				target = "https://iepdev.dev.cu.edu/psp/iepdev/UCB2/ENTP/h/?tab=CU_FACULTY";
			} else if (envURL.indexOf("icstst") > -1) {
				target = "https://ieptst.qa.cu.edu/psp/ieptst/UCB2/ENTP/h/?tab=CU_FACULTY";
			} else if (envURL.indexOf("icsstg") > -1) {
				target = "https://iepstg.qa.cu.edu/psp/iepstg/UCB2/ENTP/h/?tab=CU_FACULTY";
			}
			
			//Navigate
			window.location.href=target;
			
		 }); 
		 
		 
		 $('input[name="transfercontent"]').click(function(){
		 $('div#crosscontent').hide();  if ( $(this).attr("id") == 'transfer1') { $('div#crosscontent').show();} 
		 if ( $(this).attr("id") == 'transfer2') { $('div#crosscontent').show(); }
		 }); });
             

</script>

                <style>
					body {font-family:Arial, Helvetica, sans-serif;padding:2em;}
					a:focus {outline: thin dotted;}
					h1#colorboxFocus:focus {outline: thin dotted;}
					.outline {border:1px solid silver;}
					h2 {margin-bottom:0; padding-bottom:0; font-weight:normal;}
					h2 + p {margin-top:0; padding-top:0;}
					
					div#crosscontent {display:none;}
					@media print {
					.noprint {	display: none;}
					}
				</style>
			</head>
		<body style="padding-top:0;" onLoad="document.getElementById('colorboxFocus').focus();">
				
<div class="noprint">
<table cellspacing="0" cellpadding="6" border="0" width="100%">
                            <tr>
		<td align="right"><a href="#" class="backButton">Back to Portal</a></td>
  </tr>
 </table>
</div>
               <h1 id="colorboxFocus" tabindex="-1">Request Changes to Desire2Learn (D2L) Course</h1>
				<p>You are requesting D2L changes for the following course: </p>
				<xsl:apply-templates select="course"/>
				
				<xsl:apply-templates select="request-form"/>
				
				
				<p>&#160;</p>
				
			</body>
            </html>
	</xsl:template>
	
	<xsl:template match="course">
		
			<xsl:value-of select="dept"/>&#160;<xsl:value-of select="code"/>-<xsl:value-of select="section"/>
			<br/>
			<xsl:value-of select="title"/>
			<br/>
			<xsl:call-template name="parseTerm">
				<xsl:with-param name="thisTerm" select="term" />
			</xsl:call-template>
		
	</xsl:template>
	
	<xsl:template name="parseTerm">
		<xsl:param name="thisTerm" />
		<xsl:choose>
			<xsl:when test="1=substring($thisTerm,4,1)">Spring&#160;</xsl:when>
			<xsl:when test="4=substring($thisTerm,4,1)">Summer&#160;</xsl:when>
			<xsl:when test="7=substring($thisTerm,4,1)">Fall&#160;</xsl:when>
		</xsl:choose> 20<xsl:value-of select="substring($thisTerm,2,2)" />
	</xsl:template>
	
	<xsl:template match="request-form">
		<form method="post" action="{/root/course-url/redirect}" id="D2Lform">
			<!-- Change 1: added hidden field -->
			<input type="hidden" name="TypeRequested" value="Desire2Learn"/>
			<input type="hidden" name="longName" value="{/root/course/longName}" />
			<!-- End change 1 -->
			
            <h2>Combine Sections</h2>
			<p><b>Select other courses, recitations, or labs to combine with the same D2L space as the course above.</b></p>
			
				<xsl:choose>
					<xsl:when test="count(cross-list-courses/course) = 0"> &lt;No Cross-Listed Courses Available&gt;<br/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="cross-list-courses/course">
							<xsl:variable name="thisTerm">
								<xsl:call-template name="parseTerm">
									<xsl:with-param name="thisTerm" select="term" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="thisCampus">
								<xsl:choose>
									<xsl:when test="au = 'B1'">Boulder Main Campus</xsl:when>
									<xsl:when test="au = 'B2'">Continuing Education Credit Courses</xsl:when>
									<xsl:when test="au = 'B3'">Continuing Education Noncredit Courses</xsl:when>
									<xsl:otherwise>Boulder</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="courseid"><xsl:value-of select="dept"/><xsl:value-of select="code"/>_<xsl:value-of select="section"/>_<xsl:value-of select="$thisCampus"/>_<xsl:value-of select="$thisTerm"/></xsl:variable>
							<input type="checkbox"  name="crossListCourseID" id="{$courseid}" value="{$courseid}"/>
							<label for="{$courseid}"> <xsl:value-of select="dept"/>&#160; <xsl:value-of select="code"/>-<xsl:value-of select="section"/>&#160; </label><br/>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				
			
			
			<h2>Reuse Course Content</h2>
			
				<p>To copy content from an existing course into your D2L space, please see these step-by-step instructions: <a href="http://www.colorado.edu/oit/tutorial/d2l-copy-content-between-courses" target="_blank">D2L - Copy Content Between Courses</a>. </p>
             
<h2>Adding Participants</h2>
		<p>You can add instructors, TAs and auditors not listed in the official course roster to your D2L course. Please review the options below to add participants.</p>
			
			<p><b>Option 1: Add Participants Yourself Using the D2L Classlist.</b> For instructions, please see <a href="http://www.colorado.edu/oit/tutorial/d2l-adding-participants" target="_blank">D2L - Adding Participants.</a> TAs must be added to sections. To do so, please see <a href="http://www.colorado.edu/oit/tutorial/d2l-assigning-course-participants-sections" target="_blank">D2L - Assigning Course Participants To Sections</a> </p>
            
<p><b>Option 2: Let OIT Add Participants</b> Requests are fulfilled within 2 business days. Enter the CU Identikey user name or CU email address below and specify their access level. To learn more about access levels, see <a href="http://www.colorado.edu/oit/services/teaching-learning-tools/desire2learn-d2l/help/getting-started/roles-permissions" target="_blank">D2L - Roles and Permissions</a></p>
		<div role="group" aria-label="Add User">
			<label for="ta1">IdentiKey or eMail</label>
			<input type="text" name="ta1" id="ta1" size="50"/>
			<select name="ta1Access">
				<option value="">Choose Access Level</option>
				<option value="Instructor">Instructor</option>
				<option value="TA">TA (with grade book access)</option>
				<option value="TA_no_access">TA (no grade book access)</option>
				<option value="auditor">Auditor</option>
			</select>
			<br />
			<label for="ta2">IdentiKey or eMail</label>
			<input type="text" name="ta2" id="ta2" size="50"/>
			<select name="ta2Access">
				<option value="">Choose Access Level</option>
				<option value="Instructor">Instructor</option>
				<option value="TA">TA (with grade book access)</option>
				<option value="TA_no_access">TA (no grade book access)</option>
				<option value="auditor">Auditor</option>
			</select>
			<br/>
			<label for="ta3">IdentiKey or eMail</label>
			<input type="text" name="ta3" id="ta3" size="50"/>
			<select name="ta3Access">
				<option value="">Choose Access Level</option>
				<option value="Instructor">Instructor</option>
				<option value="TA">TA (with grade book access)</option>
				<option value="TA_no_access">TA (no grade book access)</option>
				<option value="auditor">Auditor</option>
			</select>
			<br/>
			<label for="ta4">IdentiKey or eMail</label>
			<input type="text" name="ta4" id="ta4" size="50"/>
			<select name="ta4Access">
				<option value="">Choose Access Level</option>
				<option value="Instructor">Instructor</option>
				<option value="TA">TA (with grade book access)</option>
				<option value="TA_no_access">TA (no grade book access)</option>
				<option value="auditor">Auditor</option>
			</select>
			</div>
            
			<p><b><span id="specialText">Do you have a special request or questions about your D2L course space? Please use the space provided below.<br /></span></b>
				<textarea aria-labelledby="specialText" name="special-D2L" id="special-D2L" rows="5" cols="50"/>
                </p>
			
			
			<!-- Change 2: changed from type="button"  to type="submit" -->
            
			<input name="send-D2Lform" type="submit" value="Submit" />
		</form>
		
	</xsl:template>
	
</xsl:stylesheet>
