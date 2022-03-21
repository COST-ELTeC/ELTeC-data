<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:t="http://www.tei-c.org/ns/1.0"
 xmlns:e="http://distantreading.net/eltec/ns"
 exclude-result-prefixes="xs t e"
 version="2.0">
 
 <!-- script to produce data for word embedding experiment (LB 2021-06-30)
  
  Invoked from python script filter.py; see documentation there
 
--> 
 
 <xsl:output media-type="text"  omit-xml-declaration="yes" />
 
 <xsl:param name="wot">lemma</xsl:param>
 <xsl:param name="pos">CONTENT</xsl:param>
 
 
 <xsl:template match="t:date">
  <xsl:choose>
   <xsl:when test="contains(., '(')">
    <xsl:value-of select="substring-before(substring-after(.,'('),')')"/>
   </xsl:when>
   <xsl:when test="contains(., '-')">
    <xsl:value-of select="substring-before(.,'-')"/>
   </xsl:when>
   <xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
  </xsl:choose> 
  
 </xsl:template>
 

 <xsl:template match="/">

  
  <xsl:variable name="dateStr">
   <xsl:choose>
    
    <!-- use first firstEdition date if there is one -->
    
    <xsl:when
     test="string-length(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'firstEdition'][1]/t:date[1]) gt 1">
     <xsl:apply-templates select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'firstEdition'][1]/t:date[1]"/>
     
     <!--<xsl:value-of
      select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'firstEdition']/t:date[1])"
     />
  -->  </xsl:when>
    <xsl:when
     test="string-length(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'printSource'][1]/t:date) gt 1">
     
     <!-- failing which, use printSource date -->
     <xsl:apply-templates select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'printSource'][1]/t:date[1]"/>
    <!-- 
     <xsl:variable name="year"><xsl:value-of
      select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'printSource']/t:date[1])"
     /></xsl:variable>
     <xsl:choose>
      <xsl:when test="contains($year, '(')">
       <xsl:value-of select="substring-before(substring-after($year,'('),')')"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$year"/></xsl:otherwise>
     </xsl:choose> -->
    </xsl:when>
    <!-- failing which, use whatever date you can find-->
    <xsl:when
     test="string-length(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl/t:date) gt 1">
     
    <xsl:apply-templates select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl/t:date[1]"/>
  <!--    <xsl:value-of
      select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl/t:date[1])"
     />--></xsl:when>
    <xsl:otherwise>
     <xsl:text>1800</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

<xsl:variable name="date">
 <xsl:choose>
  <xsl:when test="contains($dateStr,'-')"><xsl:value-of select="substring-before($dateStr,'-')"/></xsl:when>
  <xsl:otherwise><xsl:value-of select="$dateStr"/></xsl:otherwise>
 </xsl:choose>
</xsl:variable>
  

   <xsl:variable name="fName"> 
   <xsl:value-of select="concat(/t:TEI/@xml:id,'_',$date,//t:textDesc/e:timeSlot/@key,
   //t:textDesc/e:authorGender/@key,
 upper-case(substring(//t:textDesc/e:size/@key,1,1)),
  upper-case(substring(//t:textDesc/e:canonicity/@key,1,1)),
   upper-case(substring(//t:textDesc/e:reprintCount/@key,1,1)),
  '.txt')"/>
  </xsl:variable>
  <xsl:message><xsl:value-of select="$fName"/></xsl:message>
<!--  <xsl:message>Filtering <xsl:value-of select="$wot"/> on   <xsl:value-of select="$pos"/></xsl:message>
--> <xsl:result-document href="{$fName}">
  <xsl:choose>
   <xsl:when test="$pos='CONTENT'">
    <xsl:apply-templates select="//t:body//t:w[matches(@pos,'NOUN|ADJ|ADV|VERB')]"/>
   </xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates select="//t:body//t:w[starts-with(@pos,$pos)]"/>
 </xsl:otherwise></xsl:choose> </xsl:result-document>
 </xsl:template> 
 <xsl:template match="t:w">
  <xsl:choose>
   <xsl:when test="$wot eq 'lemma'">
    <xsl:value-of select="@lemma"/>
   </xsl:when>
   <xsl:when test="$wot eq 'form'">
    <xsl:value-of select="."/>
   </xsl:when>
   <xsl:otherwise/>
  </xsl:choose>
  <xsl:text> </xsl:text>
 </xsl:template>
 
</xsl:stylesheet>
