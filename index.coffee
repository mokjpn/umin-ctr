request = require 'request'
cheerio = require 'cheerio'
iconv = require 'iconv-lite'

module.exports = (id,rid, fun) ->
  if ! (id || rid )
    return null # id か rid のどれかは必須

  if rid
    return getbyrid rid,fun
  else if id
    console.log "Obtaining Registration ID from UMIN ID..."
    # UMIN-CTRを検索してridを得る
    request.post({
      url: 'https://upload.umin.ac.jp/cgi-open-bin/ctr/index.cgi',
      form:
        sort: '03'
        function: '04'
        ids: id
      encoding: null,
      strictSSL: false },
      (error,response,body) ->
        if  !error && response.statusCode == 200
          body = iconv.decode body,'UTF-8'
          #console.log body
          $ = cheerio.load body
          match = $("td:contains('閲覧'):not([bgcolor])").find('a').attr('href').match(/recptno=(R[0-9]+)/)
          if  ! match
            return null
          rid = match[1]
          #console.log rid
          return getbyrid rid, fun
        else
          return null
      )
    return true

getbyrid = (rid, fun) ->
    console.log "GetbyRID: " + rid
    request.get({
      url: "https://upload.umin.ac.jp/cgi-open-bin/ctr/ctr_view.cgi?recptno=#{rid}"
      encoding: null,
      strictSSL: false },
      (error,response,body) ->
        if  !error && response.statusCode == 200
          body = iconv.decode body,'UTF-8'
          #console.log body
          $ = cheerio.load body
          js = umin2json rid,$
          fun js
      )
    return true

umin2json = (rid,$) ->
  trial =
    title:  $("tr:first-child:contains('基本情報/Basic information')").siblings().children("td:first-child:contains('Official scientific title of the study')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
    title_en:  $("tr:first-child:contains('基本情報/Basic information')").siblings().children("td:first-child:contains('Official scientific title of the study')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,"")
    subtitle:  $("tr:first-child:contains('基本情報/Basic information')").siblings().children("td:first-child:contains('Title of the study (Brief title)')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
    subtitle_en:  $("tr:first-child:contains('基本情報/Basic information')").siblings().children("td:first-child:contains('Title of the study (Brief title)')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,"")
    id: $("tr td:first-child:contains('UMIN試験ID')").siblings("td:nth-child(2)").text().replace(/[\r\n\t]/g,"")
    URL: $("tr:first-child:contains('閲覧ページへのリンク')").siblings().children("td:first-child:contains('URL(日本語)')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
    URL_en: $("tr:first-child:contains('閲覧ページへのリンク')").siblings().children("td:first-child:contains('URL(英語)')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
    rid: rid
    pubdate: $("tr td[bgcolor='#FFFF99']:first-child:contains('一般公開日（本登録希望日）')").siblings("td:nth-child(2)").text().replace(/[\r\n\t]/g,"")
    progress: $("tr td[bgcolor='#FFFF99']:first-child:contains('試験進捗状況')").siblings("td:nth-child(2)").text().replace(/[\r\n\t]/g,"")
    contact:
      mail: $("tr:first-child:contains('Public contact')").siblings("tr:contains('Email')").children("td:nth-child(2)").text().replace(/[\r\n\t]/g,"")
      name: $("tr:first-child:contains('Public contact')").siblings("tr:contains('Name of contact person')").children("td:nth-child(2)").text().replace(/[\r\n\t]/g,"")
      name_en: $("tr:first-child:contains('Public contact')").siblings("tr:contains('Name of contact person')").children("td:nth-child(3)").text().replace(/[\r\n\t]/g,"")
      org: $("tr:first-child:contains('Public contact')").siblings("tr:contains('Organization')").children("td:nth-child(2)").text().replace(/[\r\n\t]/g,"")
      org_en: $("tr:first-child:contains('Public contact')").siblings("tr:contains('Organization')").children("td:nth-child(3)").text().replace(/[\r\n\t]/g,"")
    objective:
      objective1: $("tr:first-child:contains('目的/Objectives')").siblings().children("td:first-child:contains('目的1/Narrative objectives1')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      objective1_en: $("tr:first-child:contains('目的/Objectives')").siblings().children("td:first-child:contains('目的1/Narrative objectives1')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,"")
      objective2: $("tr:first-child:contains('目的/Objectives')").siblings().children("td:first-child:contains('目的2/Basic objectives2')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
    outcome:
      primary: $("tr:first-child:contains('評価/Assessment')").siblings().children("td:first-child:contains('主要アウトカム評価項目')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      primary_en: $("tr:first-child:contains('評価/Assessment')").siblings().children("td:first-child:contains('主要アウトカム評価項目')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,"")
      secondary: $("tr:first-child:contains('評価/Assessment')").siblings().children("td:first-child:contains('副次アウトカム評価項目')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      secondary_en: $("tr:first-child:contains('評価/Assessment')").siblings().children("td:first-child:contains('副次アウトカム評価項目')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,"")
    design:
      type: $("tr:first-child:contains('基本事項/Base')").siblings().children("td:first-child:contains('試験の種類')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      basic: $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('基本デザイン')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      randomization: $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('/Randomization')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      randomizationunit: $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('ランダム化の単位')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      blinding: $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('ブラインド化')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      control: $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('コントロール')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      stratification: $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('層別化')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      dynamic:  $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('動的割付')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      institutionblock: $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('試験実施施設の考慮')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      blocking: $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('ブロック化')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      concealment: $("tr:first-child:contains('試験デザイン/Study design')").siblings().children("td:first-child:contains('割付コードを知る方法')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
    eligibility:
      samplesize: $("tr:first-child:contains('Eligibility')").siblings().children("td:first-child:contains('目標参加者数')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      inclusion: $("tr:first-child:contains('Eligibility')").siblings().children("td:first-child:contains('選択基準')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      inclusion_en: $("tr:first-child:contains('Eligibility')").siblings().children("td:first-child:contains('選択基準')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,"")
      exclusion: $("tr:first-child:contains('Eligibility')").siblings().children("td:first-child:contains('除外基準')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      exclusion_en: $("tr:first-child:contains('Eligibility')").siblings().children("td:first-child:contains('除外基準')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,"")
    relinfo:
      other: $("tr:first-child:contains('Related information')").siblings().children("td:first-child:contains('その他関連情報')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      other_en: $("tr:first-child:contains('Related information')").siblings().children("td:first-child:contains('その他関連情報')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,"")
      publication:  $("tr:first-child:contains('Related information')").siblings().children("td:first-child:contains('試験結果の公開状況')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
    intervention:
      narms: $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('群数')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      purpose: $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('介入の目的')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      type: $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('介入の種類')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
      interventions: [
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_1')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_2')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_3')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_4')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_5')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_6')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_7')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_8')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_9')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_10')").siblings(":nth-child(2)").text().replace(/[\r\n\t]/g,"")
        ]
      interventions_en: [
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_1')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_2')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_3')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_4')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_5')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_6')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_7')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_8')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_9')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,""),
        $("tr:first-child:contains('介入/Intervention')").siblings().children("td:first-child:contains('Interventions/Control_10')").siblings(":nth-child(3)").text().replace(/[\r\n\t]/g,"")
        ]

  return trial
