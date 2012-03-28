<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="next-day-date">
  <xsl:param name="date"/> <!-- format is YYYY-MM-DD -->

  <xsl:param name="old_year" select="number(substring($date, 1, 4))"/>
  <xsl:param name="old_month" select="number(substring($date, 6, 2))"/>
  <xsl:param name="old_day" select="number(substring($date, 9, 2))"/>

  <xsl:variable name="days-of-month">
    <xsl:call-template name="days-of-month">
      <xsl:with-param name="date" select="$date"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="year">
    <xsl:choose>
      <xsl:when test="$old_month=12 and $old_day=$days-of-month">
        <xsl:value-of select="$old_year+1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$old_year"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="tmp_month">
    <xsl:choose>
      <xsl:when test="$year!=$old_year">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:when test="$old_day=$days-of-month">
        <xsl:value-of select="$old_month+1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$old_month"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="tmp_day">
    <xsl:choose>
      <xsl:when test="$tmp_month!=$old_month">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$old_day+1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="month">
    <xsl:if test="$tmp_month &lt; 10">
      <xsl:text>0</xsl:text>
    </xsl:if>
    <xsl:value-of select="$tmp_month"/>
  </xsl:variable>

  <xsl:variable name="day">
    <xsl:if test="$tmp_day &lt; 10">
      <xsl:text>0</xsl:text>
    </xsl:if>
    <xsl:value-of select="$tmp_day"/>
  </xsl:variable>

  <xsl:value-of select="$year"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="$month"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="$day"/>
  
</xsl:template>
  
  
<xsl:template name="days-of-month">
  <xsl:param name="date"/>
  <xsl:param name="month" select="number(substring($date, 6, 2))"/>
  
  <xsl:variable name="is-leap-year">
    <xsl:call-template name="is-leap-year">
      <xsl:with-param name="date" select="$date"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="$month=4 or $month=6 or $month=9 or $month=11">
      <xsl:text>30</xsl:text>
    </xsl:when>
    <xsl:when test="$month=2 and $is-leap-year">
      <xsl:text>29</xsl:text>
    </xsl:when>
    <xsl:when test="$month=2">
      <xsl:text>28</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>31</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>
  
<xsl:template name="is-leap-year">
  <xsl:param name="date"/>
  <xsl:param name="year" select="substring($date, 1, 4)"/>
  
  <xsl:value-of select="($year mod 4 = 0 and $year mod 100 != 0) or $year mod 400 = 0"/>
  
</xsl:template>

</xsl:stylesheet>
