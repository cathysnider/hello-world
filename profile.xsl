<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="root">
<div id="mycuinfoprofile">
<!-- DON'T NEED HEADER
<h2 id="profilelabel" class="element-invisible">Profile and Settings</h2>-->
<script type="text/javascript">

$(document).ready(function() {
$("div#personalInfo").hide();	

$("a#profileLink").click(function(){
	var pglt_link_state = $(this).attr("aria-expanded");
	$(this).toggleClass("closeProfile");
	$(this).toggleClass("openProfile");
	$("div#personalInfo").slideToggle();
	if (pglt_link_state == "false") {
		$(this).attr("aria-expanded","true");
		$("div#personalInfo").attr("aria-hidden","false");
		}
		
	if (pglt_link_state == "true") {
		$(this).attr("aria-expanded","false");
		$("div#personalInfo").attr("aria-hidden","true");	
	}
});	
				
				
               $("#d2lLink").attr("href", document.location.href.replace(/\/psp\//, "/psc/").replace(/\/h\/.*$/, "/s/WEBLIB_CU_D2L.ISCRIPT1.FieldFormula.IScript_ShowD2LPagelet"));  
});

</script>

			<!-- process the affiliations for email -->
			<xsl:apply-templates select="demographicData/affiliations" />
			<!-- create Desire2Learn link -->
<xsl:if test="lms='CULEARN'">
<div class="link"><a href="https://learn.colorado.edu" id="d2lLink" target="_blank">Desire2Learn</a></div>
</xsl:if>
			<!-- process personal info -->
 <div class="link"><h2><a href="javascript:void(0);" id="profileLink" class="closeProfile" aria-controls="personalInfo" aria-expanded="false">Profile and Settings</a></h2></div>
 
		  <div class="toggle_content" id="personalInfo" aria-hidden="true">
				<table class="tbl-profile" role="presentation">
					<tr>
						<td colspan="2">
							<h3>Personal Info</h3>
						</td>
					</tr>
					<xsl:if test="cs_id">
						<tr>
							<td>
								<strong>Student ID:</strong>
							</td>
							<td>
								<xsl:value-of select="cs_id" />
							</td>
						</tr>
					</xsl:if>
				
						<xsl:if test="hr_id">
						<tr>
						<td>
						<strong>Employee ID:</strong>
						</td>
						<td>
						<xsl:value-of select="hr_id" />
						</td>
						</tr>
						</xsl:if>
					
					
					<xsl:apply-templates select="demographicData" />
					<xsl:apply-templates select="collegeDatas" />
				</table>
				<!-- create helpful links -->
				<table class="tbl-profile" role="presentation">
          <tr>
            <td><h3>Account Settings</h3>
             
		<ul id="helpfullinks">    
 <li><a href="http://cuidm.colorado.edu/?SelectAccessData=true" target="_blank">IdentiKey Options</a></li>

<li><a href="../../HRMS/c/SA_LEARNER_SERVICES.SSS_STUDENT_CENTER.GBL#pop-7">Manage Profile and Privacy</a></li>

</ul>  
		  </td>
          </tr>
         
        </table>
			</div>
		</div>

	</xsl:template>
	<xsl:template match="demographicData">
		<tr>
			<td>
				<strong>Name:</strong>
			</td>
			<td>
				<xsl:value-of select="prefFirstName" />
				<xsl:text> </xsl:text>
				<xsl:value-of select="prefLastName" />
			</td>
		</tr>
        <!-- don't show affiliations 
		<xsl:for-each select="affiliations/affiliation">
			<tr>
				<td>
					<strong>Affiliation:</strong>
				</td>
				<td>
					<xsl:value-of select="." />
				</td>
			</tr>
		</xsl:for-each>
        -->
	</xsl:template>
	<xsl:template match="collegeDatas">
		<xsl:apply-templates select="collegeData"></xsl:apply-templates>	
		
	</xsl:template>
	
	
	<xsl:template match="collegeDatas">
		<xsl:for-each select="collegeData">
			<tr>
				<td>
					<strong>College:</strong>
				</td>
				<td>
					<xsl:value-of select="primaryCollege" />
				</td>
			</tr>
			<xsl:if test="primaryMajor != '' ">
				<tr>
					<td>
						<strong>Major:</strong>
					</td>
					<td>
						<!-- test for improperly escaped ampersands in data field -->
						<xsl:choose>
							<xsl:when test="contains(primaryMajor, '&amp;amp;')">
								
								<xsl:value-of select="substring-before(primaryMajor, '&amp;amp;')"></xsl:value-of>
								<xsl:text> &amp; </xsl:text>
								<xsl:value-of select="substring-after(primaryMajor, '&amp;amp;')"></xsl:value-of>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="primaryMajor" />
							</xsl:otherwise>
						</xsl:choose>
						
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="secondaryMinor != '' ">
				<tr>
					<td>
						<strong>Minor:</strong>
					</td>
					<td>
						<!-- test for improperly escaped ampersands in data field -->	
						<xsl:choose>
							<xsl:when test="contains(secondaryMinor, '&amp;amp;')">
								
								<xsl:value-of select="substring-before(secondaryMinor, '&amp;amp;')"></xsl:value-of>
								<xsl:text> &amp; </xsl:text>
								<xsl:value-of select="substring-after(secondaryMinor, '&amp;amp;')"></xsl:value-of>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="secondaryMinor" />
							</xsl:otherwise>
						</xsl:choose>
						
						
					</td>
				</tr>
			</xsl:if>
			<!-- no Class Standings until better data is formulated 
				<tr>
				<td>
				<strong>Class Standing:</strong>
				</td>
				<td>
				<xsl:value-of select="classStanding" />
				</td>
				</tr>
			-->
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="demographicData/affiliations">
		<xsl:if test="(affiliation = 'FACULTY') or (affiliation = 'ADVISOR')"><div class="link"><a href="https://outlook.office365.com/" target="_blank">Office 365 Outlook</a></div></xsl:if>
		<xsl:if test="affiliation = 'STUDENT'"><div class="link"><a href="http://gmail.colorado.edu" target="_blank">Gmail</a></div></xsl:if>		
	</xsl:template>
	
	
	
</xsl:stylesheet>
