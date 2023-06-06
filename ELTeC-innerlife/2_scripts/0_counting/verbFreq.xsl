<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:saxon='http://saxon.sf.net'
 xmlns:t="http://www.tei-c.org/ns/1.0"
 exclude-result-prefixes="xs t"
 version="2.0">
 
 <!-- produces frequency lists for Pieter's  word embedding experiment (LB 2021-10-28) -->
 
 <!-- to run against corpus xxx
       saxon -xi ELTeC-xxx/driver-2.tei verbFreq.xsl  
 -->
 
 
 <xsl:output omit-xml-declaration="yes"/>
 
  <xsl:template match="/">
   <frequencies><xsl:text>
</xsl:text>
    <xsl:for-each-group group-by="." select="//t:w[@pos='VERB']/@lemma" >
<!--  select= "for $w in tokenize(string(.), '\W+') return lower-case($w)">
-->  
     <xsl:sort select="count(current-group())" order="descending"/>
     <xsl:variable name="freq" select="count(current-group())"/>
<xsl:if test="$freq &gt; 100">
    <xsl:variable name="form" select="current-grouping-key()"/>
 <xsl:choose>
  <xsl:when test="contains($form,'|')">
 <lemma form="{substring-before($form,'|')}"
      freq="{$freq}"/>
  </xsl:when>
  <xsl:otherwise>
 <lemma form="{$form}" freq="{$freq}"/>
  </xsl:otherwise>
 </xsl:choose>
     <xsl:text>
</xsl:text>
 </xsl:if>
    </xsl:for-each-group>
   </frequencies>
  </xsl:template>

 
</xsl:stylesheet>
