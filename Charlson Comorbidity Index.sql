-- ============================================================
-- Charlson Comorbidity Index (CCI) and Age-adjusted CCI (ACCI)
-- Charlson Comorbidity Index BEFORE Index Date
-- CharlsonM, Szatrowski TP, Peterson J, Gold J. Validation of a combined comorbidity index. J Clin Epidemiol. 1994;47(11):1245-1251.
-- ============================================================


-- ============================================================
-- step 0: clean up temp tables
-- ============================================================

if object_id('tempdb..#dx_term_icd10') is not null drop table #dx_term_icd10;
if object_id('tempdb..#CodeSet_cci_mi') is not null drop table #CodeSet_cci_mi;
if object_id('tempdb..#CodeSet_cci_chf') is not null drop table #CodeSet_cci_chf;
if object_id('tempdb..#CodeSet_cci_pvd') is not null drop table #CodeSet_cci_pvd;
if object_id('tempdb..#CodeSet_cci_cevd') is not null drop table #CodeSet_cci_cevd;
if object_id('tempdb..#CodeSet_cci_dementia') is not null drop table #CodeSet_cci_dementia;
if object_id('tempdb..#CodeSet_cci_pulm') is not null drop table #CodeSet_cci_pulm;
if object_id('tempdb..#CodeSet_cci_rheum') is not null drop table #CodeSet_cci_rheum;
if object_id('tempdb..#CodeSet_cci_pud') is not null drop table #CodeSet_cci_pud;
if object_id('tempdb..#CodeSet_cci_mild_liver') is not null drop table #CodeSet_cci_mild_liver;
if object_id('tempdb..#CodeSet_cci_dm_no_cc') is not null drop table #CodeSet_cci_dm_no_cc;
if object_id('tempdb..#CodeSet_cci_dm_cc') is not null drop table #CodeSet_cci_dm_cc;
if object_id('tempdb..#CodeSet_cci_hemi') is not null drop table #CodeSet_cci_hemi;
if object_id('tempdb..#CodeSet_cci_renal') is not null drop table #CodeSet_cci_renal;
if object_id('tempdb..#CodeSet_cci_cancer') is not null drop table #CodeSet_cci_cancer;
if object_id('tempdb..#CodeSet_cci_severe_liver') is not null drop table #CodeSet_cci_severe_liver;
if object_id('tempdb..#CodeSet_cci_mets') is not null drop table #CodeSet_cci_mets;
if object_id('tempdb..#CodeSet_cci_aids') is not null drop table #CodeSet_cci_aids;
if object_id('tempdb..#CodeSet_cci_all') is not null drop table #CodeSet_cci_all;
if object_id('tempdb..#cci_dx') is not null drop table #cci_dx;
if object_id('tempdb..#cci_flags_raw') is not null drop table #cci_flags_raw;
if object_id('tempdb..#cci_flags') is not null drop table #cci_flags;
if object_id('tempdb..#cci_final') is not null drop table #cci_final;
if object_id('tempdb..#cci_final') is not null drop table #acci_final;

-- ============================================================
-- step 1: normalize icd-10-cm terminology codes
-- code_nodot is used for easier matching
-- ============================================================

select distinct
    DiagnosisKey,
    Type,
    Value,
    replace(upper(Value), '.', '') as code_nodot
into #dx_term_icd10
from dbo.diagnosisterminologydim
where Type = 'ICD-10-CM'
  and Value is not null;

-- select top 100 * from #dx_term_icd10


-- ============================================================
-- step 2: build cci code sets
-- ============================================================

-- myocardial infarction (weight 1)
select distinct
    'mi' as comorbidity,
    DiagnosisKey,
    code_nodot
into #CodeSet_cci_mi
from #dx_term_icd10
where code_nodot like 'I21%'
   or code_nodot like 'I22%'
   or code_nodot like 'I252%';

select top 100 * from #CodeSet_cci_mi;


-- congestive heart failure (weight 1)
select distinct
    'chf' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_chf
from #dx_term_icd10
where code_nodot like 'I43%'
   or code_nodot like 'I50%'
   or code_nodot like 'I099%'
   or code_nodot like 'I110%'
   or code_nodot like 'I130%'
   or code_nodot like 'I132%'
   or code_nodot like 'I255%'
   or code_nodot like 'I420%'
   or code_nodot like 'I425%'
   or code_nodot like 'I426%'
   or code_nodot like 'I427%'
   or code_nodot like 'I428%'
   or code_nodot like 'I429%'
   or code_nodot like 'P290%';


-- peripheral vascular disease (weight 1)
select distinct
    'pvd' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_pvd
from #dx_term_icd10
where code_nodot like 'I70%'
   or code_nodot like 'I71%'
   or code_nodot like 'I731%'
   or code_nodot like 'I738%'
   or code_nodot like 'I739%'
   or code_nodot like 'I771%'
   or code_nodot like 'I790%'
   or code_nodot like 'I792%'
   or code_nodot like 'K551%'
   or code_nodot like 'K558%'
   or code_nodot like 'K559%'
   or code_nodot like 'Z958%'
   or code_nodot like 'Z959%';


-- cerebrovascular disease (weight 1)
select distinct
    'cevd' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_cevd
from #dx_term_icd10
where code_nodot like 'G45%'
   or code_nodot like 'G46%'
   or code_nodot like 'H340%'
   or code_nodot like 'I60%'
   or code_nodot like 'I61%'
   or code_nodot like 'I62%'
   or code_nodot like 'I63%'
   or code_nodot like 'I64%'
   or code_nodot like 'I65%'
   or code_nodot like 'I66%'
   or code_nodot like 'I67%'
   or code_nodot like 'I68%'
   or code_nodot like 'I69%';


-- dementia (weight 1)
select distinct
    'dementia' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_dementia
from #dx_term_icd10
where code_nodot like 'F00%'
   or code_nodot like 'F01%'
   or code_nodot like 'F02%'
   or code_nodot like 'F03%'
   or code_nodot like 'F051%'
   or code_nodot like 'G30%'
   or code_nodot like 'G311%';


-- chronic pulmonary disease (weight 1)
select distinct
    'pulm' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_pulm
from #dx_term_icd10
where code_nodot like 'I278%'
   or code_nodot like 'I279%'
   or code_nodot like 'J40%'
   or code_nodot like 'J41%'
   or code_nodot like 'J42%'
   or code_nodot like 'J43%'
   or code_nodot like 'J44%'
   or code_nodot like 'J45%'
   or code_nodot like 'J46%'
   or code_nodot like 'J47%'
   or code_nodot like 'J60%'
   or code_nodot like 'J61%'
   or code_nodot like 'J62%'
   or code_nodot like 'J63%'
   or code_nodot like 'J64%'
   or code_nodot like 'J65%'
   or code_nodot like 'J66%'
   or code_nodot like 'J67%'
   or code_nodot like 'J684%'
   or code_nodot like 'J701%'
   or code_nodot like 'J703%';


-- rheumatic disease/connective tissue (weight 1)
select distinct
    'rheum' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_rheum
from #dx_term_icd10
where code_nodot like 'M05%'
   or code_nodot like 'M06%'
   or code_nodot like 'M32%'
   or code_nodot like 'M33%'
   or code_nodot like 'M34%'
   or code_nodot like 'M315%'
   or code_nodot like 'M351%'
   or code_nodot like 'M353%'
   or code_nodot like 'M360%';


-- peptic ulcer disease (weight 1)
select distinct
    'pud' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_pud
from #dx_term_icd10
where code_nodot like 'K25%'
   or code_nodot like 'K26%'
   or code_nodot like 'K27%'
   or code_nodot like 'K28%';


-- mild liver disease (weight 1)
select distinct
    'mild_liver' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_mild_liver
from #dx_term_icd10
where code_nodot like 'B18%'
   or code_nodot like 'K700%'
   or code_nodot like 'K701%'
   or code_nodot like 'K702%'
   or code_nodot like 'K703%'
   or code_nodot like 'K709%'
   or code_nodot like 'K713%'
   or code_nodot like 'K714%'
   or code_nodot like 'K715%'
   or code_nodot like 'K717%'
   or code_nodot like 'K73%'
   or code_nodot like 'K74%'
   or code_nodot like 'K760%'
   or code_nodot like 'K762%'
   or code_nodot like 'K763%'
   or code_nodot like 'K764%'
   or code_nodot like 'K768%'
   or code_nodot like 'K769%'
   or code_nodot like 'Z944%';


-- diabetes without chronic complications (weight 1)
select distinct
    'dm_no_cc' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_dm_no_cc
from #dx_term_icd10
where code_nodot like 'E100%'
   or code_nodot like 'E101%'
   or code_nodot like 'E106%'
   or code_nodot like 'E108%'
   or code_nodot like 'E109%'
   or code_nodot like 'E110%'
   or code_nodot like 'E111%'
   or code_nodot like 'E116%'
   or code_nodot like 'E118%'
   or code_nodot like 'E119%'
   or code_nodot like 'E120%'
   or code_nodot like 'E121%'
   or code_nodot like 'E126%'
   or code_nodot like 'E128%'
   or code_nodot like 'E129%'
   or code_nodot like 'E130%'
   or code_nodot like 'E131%'
   or code_nodot like 'E136%'
   or code_nodot like 'E138%'
   or code_nodot like 'E139%'
   or code_nodot like 'E140%'
   or code_nodot like 'E141%'
   or code_nodot like 'E146%'
   or code_nodot like 'E148%'
   or code_nodot like 'E149%';


-- diabetes with chronic complications (weight 2)
select distinct
    'dm_cc' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_dm_cc
from #dx_term_icd10
where code_nodot like 'E102%'
   or code_nodot like 'E103%'
   or code_nodot like 'E104%'
   or code_nodot like 'E105%'
   or code_nodot like 'E107%'
   or code_nodot like 'E112%'
   or code_nodot like 'E113%'
   or code_nodot like 'E114%'
   or code_nodot like 'E115%'
   or code_nodot like 'E117%'
   or code_nodot like 'E122%'
   or code_nodot like 'E123%'
   or code_nodot like 'E124%'
   or code_nodot like 'E125%'
   or code_nodot like 'E127%'
   or code_nodot like 'E132%'
   or code_nodot like 'E133%'
   or code_nodot like 'E134%'
   or code_nodot like 'E135%'
   or code_nodot like 'E137%'
   or code_nodot like 'E142%'
   or code_nodot like 'E143%'
   or code_nodot like 'E144%'
   or code_nodot like 'E145%'
   or code_nodot like 'E147%';


-- hemiplegia / paraplegia (weight 2)
select distinct
    'hemi' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_hemi
from #dx_term_icd10
where code_nodot like 'G041%'
   or code_nodot like 'G114%'
   or code_nodot like 'G801%'
   or code_nodot like 'G802%'
   or code_nodot like 'G81%'
   or code_nodot like 'G82%'
   or code_nodot like 'G830%'
   or code_nodot like 'G831%'
   or code_nodot like 'G832%'
   or code_nodot like 'G833%'
   or code_nodot like 'G834%'
   or code_nodot like 'G839%';


-- moderate/severe renal disease (weight 2)
select distinct
    'renal' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_renal
from #dx_term_icd10
where code_nodot like 'I120%'
   or code_nodot like 'I131%'
   or code_nodot like 'N032%'
   or code_nodot like 'N033%'
   or code_nodot like 'N034%'
   or code_nodot like 'N035%'
   or code_nodot like 'N036%'
   or code_nodot like 'N037%'
   or code_nodot like 'N052%'
   or code_nodot like 'N053%'
   or code_nodot like 'N054%'
   or code_nodot like 'N055%'
   or code_nodot like 'N056%'
   or code_nodot like 'N057%'
   or code_nodot like 'N18%'
   or code_nodot like 'N19%'
   or code_nodot like 'N250%'
   or code_nodot like 'Z490%'
   or code_nodot like 'Z491%'
   or code_nodot like 'Z492%'
   or code_nodot like 'Z940%'
   or code_nodot like 'Z992%';


-- any malignancy, including leukemia and lymphoma, except metastatic solid tumor (weight 2)
select distinct
    'cancer' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_cancer
from #dx_term_icd10
where (
        code_nodot like 'C0%'
     or code_nodot like 'C1%'
     or code_nodot like 'C2%'
     or code_nodot like 'C30%'
     or code_nodot like 'C31%'
     or code_nodot like 'C32%'
     or code_nodot like 'C33%'
     or code_nodot like 'C34%'
     or code_nodot like 'C37%'
     or code_nodot like 'C38%'
     or code_nodot like 'C39%'
     or code_nodot like 'C40%'
     or code_nodot like 'C41%'
     or code_nodot like 'C43%'
     or code_nodot like 'C45%'
     or code_nodot like 'C46%'
     or code_nodot like 'C47%'
     or code_nodot like 'C48%'
     or code_nodot like 'C49%'
     or code_nodot like 'C50%'
     or code_nodot like 'C51%'
     or code_nodot like 'C52%'
     or code_nodot like 'C53%'
     or code_nodot like 'C54%'
     or code_nodot like 'C55%'
     or code_nodot like 'C56%'
     or code_nodot like 'C57%'
     or code_nodot like 'C58%'
     or code_nodot like 'C6%'
     or code_nodot like 'C70%'
     or code_nodot like 'C71%'
     or code_nodot like 'C72%'
     or code_nodot like 'C73%'
     or code_nodot like 'C74%'
     or code_nodot like 'C75%'
     or code_nodot like 'C76%'
     or code_nodot like 'C81%'
     or code_nodot like 'C82%'
     or code_nodot like 'C83%'
     or code_nodot like 'C84%'
     or code_nodot like 'C85%'
     or code_nodot like 'C88%'
     or code_nodot like 'C90%'
     or code_nodot like 'C91%'
     or code_nodot like 'C92%'
     or code_nodot like 'C93%'
     or code_nodot like 'C94%'
     or code_nodot like 'C95%'
     or code_nodot like 'C96%'
     or code_nodot like 'C97%'
      )
  and code_nodot not like 'C77%'
  and code_nodot not like 'C78%'
  and code_nodot not like 'C79%'
  and code_nodot not like 'C80%';


-- moderate/severe liver disease (weight 3)
select distinct
    'severe_liver' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_severe_liver
from #dx_term_icd10
where code_nodot like 'I850%'
   or code_nodot like 'I859%'
   or code_nodot like 'I864%'
   or code_nodot like 'I982%'
   or code_nodot like 'K704%'
   or code_nodot like 'K711%'
   or code_nodot like 'K721%'
   or code_nodot like 'K729%'
   or code_nodot like 'K765%'
   or code_nodot like 'K766%'
   or code_nodot like 'K767%';


-- metastatic solid tumor (weight 6)
select distinct
    'mets' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_mets
from #dx_term_icd10
where code_nodot like 'C77%'
   or code_nodot like 'C78%'
   or code_nodot like 'C79%'
   or code_nodot like 'C80%';


-- aids/hiv (weight 6)
select distinct
    'aids' as comorbidity,
    DiagnosisKey
into #CodeSet_cci_aids
from #dx_term_icd10
where code_nodot like 'B20%'
   or code_nodot like 'B21%'
   or code_nodot like 'B22%'
   or code_nodot like 'B24%';


-- ============================================================
-- step 3: combine all cci code sets
-- ============================================================

select comorbidity, DiagnosisKey
into #CodeSet_cci_all
from #CodeSet_cci_mi

union all select comorbidity, DiagnosisKey from #CodeSet_cci_chf
union all select comorbidity, DiagnosisKey from #CodeSet_cci_pvd
union all select comorbidity, DiagnosisKey from #CodeSet_cci_cevd
union all select comorbidity, DiagnosisKey from #CodeSet_cci_dementia
union all select comorbidity, DiagnosisKey from #CodeSet_cci_pulm
union all select comorbidity, DiagnosisKey from #CodeSet_cci_rheum
union all select comorbidity, DiagnosisKey from #CodeSet_cci_pud
union all select comorbidity, DiagnosisKey from #CodeSet_cci_mild_liver
union all select comorbidity, DiagnosisKey from #CodeSet_cci_dm_no_cc
union all select comorbidity, DiagnosisKey from #CodeSet_cci_dm_cc
union all select comorbidity, DiagnosisKey from #CodeSet_cci_hemi
union all select comorbidity, DiagnosisKey from #CodeSet_cci_renal
union all select comorbidity, DiagnosisKey from #CodeSet_cci_cancer
union all select comorbidity, DiagnosisKey from #CodeSet_cci_severe_liver
union all select comorbidity, DiagnosisKey from #CodeSet_cci_mets
union all select comorbidity, DiagnosisKey from #CodeSet_cci_aids;


-- ============================================================
-- step 4: get patient diagnoses on or before index date 
-- ============================================================

select distinct
    s.PatientDurableKey,
    s.Index_date,
    c.comorbidity
into #cci_dx
from #studyPop s
join dbo.DiagnosisEventFact d
    on s.PatientDurableKey = d.PatientDurableKey
join (
    select DateKey, DateValue as StartDate
    from dbo.DateDim
) dd
    on d.StartDateKey = dd.DateKey
join #CodeSet_cci_all c
    on d.DiagnosisKey = c.DiagnosisKey
where dd.StartDate <= s.Index_date;

-- select top 10 * from #cci_dx;


-- ============================================================
-- step 5: raw flags by patient
-- ============================================================

select
    PatientDurableKey,
    max(case when comorbidity = 'mi' then 1 else 0 end) as mi,
    max(case when comorbidity = 'chf' then 1 else 0 end) as chf,
    max(case when comorbidity = 'pvd' then 1 else 0 end) as pvd,
    max(case when comorbidity = 'cevd' then 1 else 0 end) as cevd,
    max(case when comorbidity = 'dementia' then 1 else 0 end) as dementia,
    max(case when comorbidity = 'pulm' then 1 else 0 end) as pulm,
    max(case when comorbidity = 'rheum' then 1 else 0 end) as rheum,
    max(case when comorbidity = 'pud' then 1 else 0 end) as pud,
    max(case when comorbidity = 'mild_liver' then 1 else 0 end) as mild_liver,
    max(case when comorbidity = 'dm_no_cc' then 1 else 0 end) as dm_no_cc,
    max(case when comorbidity = 'dm_cc' then 1 else 0 end) as dm_cc,
    max(case when comorbidity = 'hemi' then 1 else 0 end) as hemi,
    max(case when comorbidity = 'renal' then 1 else 0 end) as renal,
    max(case when comorbidity = 'cancer' then 1 else 0 end) as cancer,
    max(case when comorbidity = 'severe_liver' then 1 else 0 end) as severe_liver,
    max(case when comorbidity = 'mets' then 1 else 0 end) as mets,
    max(case when comorbidity = 'aids' then 1 else 0 end) as aids
into #cci_flags_raw
from #cci_dx
group by PatientDurableKey;

-- select top 10 * from #cci_flags_raw;


-- ============================================================
-- step 6: apply cci precedence rules
-- severe liver overrides mild liver
-- diabetes with complications overrides diabetes without complications
-- metastatic tumor overrides non-metastatic cancer
-- ============================================================

select
    s.PatientDurableKey,

    isnull(r.mi, 0) as mi,
    isnull(r.chf, 0) as chf,
    isnull(r.pvd, 0) as pvd,
    isnull(r.cevd, 0) as cevd,
    isnull(r.dementia, 0) as dementia,
    isnull(r.pulm, 0) as pulm,
    isnull(r.rheum, 0) as rheum,
    isnull(r.pud, 0) as pud,

    case
        when isnull(r.severe_liver, 0) = 1 then 0
        else isnull(r.mild_liver, 0)
    end as mild_liver,

    case
        when isnull(r.dm_cc, 0) = 1 then 0
        else isnull(r.dm_no_cc, 0)
    end as dm_no_cc,

    isnull(r.dm_cc, 0) as dm_cc,
    isnull(r.hemi, 0) as hemi,
    isnull(r.renal, 0) as renal,

    case
        when isnull(r.mets, 0) = 1 then 0
        else isnull(r.cancer, 0)
    end as cancer,

    isnull(r.severe_liver, 0) as severe_liver,
    isnull(r.mets, 0) as mets,
    isnull(r.aids, 0) as aids
into #cci_flags
from #studyPop s
left join #cci_flags_raw r
    on s.PatientDurableKey = r.PatientDurableKey;


-- ============================================================
-- step 7: calculate final cci score
-- ============================================================

select
    PatientDurableKey,
    mi,
    chf,
    pvd,
    cevd,
    dementia,
    pulm,
    rheum,
    pud,
    mild_liver,
    dm_no_cc,
    dm_cc,
    hemi,
    renal,
    cancer,
    severe_liver,
    mets,
    aids,

    mi
    + chf
    + pvd
    + cevd
    + dementia
    + pulm
    + rheum
    + pud
    + mild_liver
    + dm_no_cc
    + 2 * dm_cc
    + 2 * hemi
    + 2 * renal
    + 2 * cancer
    + 3 * severe_liver
    + 6 * mets
    + 6 * aids
    as CCI
into #cci_final
from #cci_flags;


-- ============================================================
-- step 8: calculate age-adjusted CCI (ACCI)
-- age points:
--   <50   = 0
--   50-59 = 1
--   60-69 = 2
--   70-79 = 3
--   >=80  = 4
-- ============================================================

select
    c.*,
    s.IndexAge,
    case
        when s.IndexAge < 50 then 0
        when s.IndexAge < 60 then 1
        when s.IndexAge < 70 then 2
        when s.IndexAge < 80 then 3
        else 4
    end as AgeScore,
    c.CCI +
    case
        when s.IndexAge < 50 then 0
        when s.IndexAge < 60 then 1
        when s.IndexAge < 70 then 2
        when s.IndexAge < 80 then 3
        else 4
    end as ACCI
into #acci_final
from #cci_final c
left join #studyPop s
    on c.PatientDurableKey = s.PatientDurableKey;


-- ============================================================
-- step 9: view final result
-- ============================================================

select top 10 * from #cci_final;

select top 10 * from #acci_final; 

