<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
 exclude-result-prefixes="xs t" version="2.0">
<xsl:output omit-xml-declaration="yes"/>
 
 <xsl:param name="lang">eng</xsl:param>
 
 <xsl:template match="/">

  <xsl:variable name="root" select="."/>
  
  <xsl:variable name="date">
   <xsl:choose>
    <xsl:when
     test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'firstEdition']">
     <xsl:value-of
      select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'firstEdition']/t:date)"
     />
    </xsl:when>
    <xsl:when
     test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'printSource']">
     <xsl:value-of
      select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl[@type = 'printSource']/t:date[1])"
     />
    </xsl:when>
    <xsl:when
     test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl/t:date">
     <xsl:value-of
      select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc//t:bibl/t:date)"
     />
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>?</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="dateYear">
   <!--<xsl:analyze-string select="$date" regex="(1[89]\d\d)">
    <xsl:matching-substring>
     <xsl:value-of select="regex-group(1)"/>
    </xsl:matching-substring>
    <xsl:non-matching-substring>?</xsl:non-matching-substring>
   </xsl:analyze-string>-->
  <xsl:choose> <xsl:when test="contains($date,'-')">
    <xsl:value-of select="substring-before($date,'-')"/>
   </xsl:when>
 <xsl:otherwise>  <xsl:value-of select="$date"/>
</xsl:otherwise>  </xsl:choose>
  </xsl:variable>

 
  <xsl:variable name="textId">
   <xsl:value-of select="/t:TEI/@xml:id"/>
  </xsl:variable>

  <xsl:variable name="verbs">
   <xsl:value-of select="count($root/t:TEI/t:text/t:body//t:w[@pos = 'VERB'])"/>
  </xsl:variable>
  
  
  <xsl:for-each select="document('/home/lou/Public/ELTeC-data/innerVerbs.xml')//list[@xml:lang=$lang]/lemma/@form">
  
  <xsl:variable name="lem">
    <xsl:value-of select="."/>
   </xsl:variable>

   <xsl:variable name="occurs">
    <xsl:value-of select="count($root/t:TEI/t:text/t:body//t:w[@lemma = $lem])"/>
   </xsl:variable>
<!--
   <xsl:message>
    <xsl:value-of select="$lem"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$occurs"/>
    <xsl:text>  </xsl:text>
    <xsl:value-of select="$occurs div $verbs * 100"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$textId"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$dateYear"/>
    <xsl:text> </xsl:text>   
   </xsl:message>-->

   <dataPoint lemma="{$lem}" year="{$dateYear}" f="{$occurs}" rf="{$occurs div $verbs * 100}" tid="{$textId}"/><xsl:text>
</xsl:text>   
   

  </xsl:for-each>
 </xsl:template>

</xsl:stylesheet>
