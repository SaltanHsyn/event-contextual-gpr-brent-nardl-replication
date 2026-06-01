' ================================================================
' EViews replication template
' Manuscript: Event-Contextual Geopolitical Risk and Brent Oil Prices
' Method: Interaction-augmented NARDL
' Author: Huseyin Saltan
' ================================================================

' NOTE:
' 1. Set the workfile/import path before running.
' 2. Variable names should match the codebook: BRENT, GPR, RU_D, IR_D, OVX, EPUTRADE.
' 3. This file documents the workflow used for reproducibility.

' Example import command; adjust local path if needed:
' wfcreate m 2007m06 2026m03
' import "data/raw/eviews_used_data.xlsx" range="Sheet1" @freq m 2007m06

' Log transformations
series ln_brent = log(brent)
series ln_gpr = log(gpr)
series ln_ovx = log(ovx)
series ln_eputrade = log(eputrade)

' Positive and negative partial sums for GPR changes
series d_lngpr = d(ln_gpr)
series gpr_pos_incr = @recode(d_lngpr > 0, d_lngpr, 0)
series gpr_neg_incr = @recode(d_lngpr < 0, d_lngpr, 0)
series gpr_pos = @cumsum(gpr_pos_incr)
series gpr_neg = @cumsum(gpr_neg_incr)

' Event-context interactions
series gpr_pos_ru = gpr_pos * ru_d
series gpr_neg_ru = gpr_neg * ru_d
series gpr_pos_ir = gpr_pos * ir_d
series gpr_neg_ir = gpr_neg * ir_d

' Unit-root tests: run ADF/PP/KPSS/Zivot-Andrews from EViews menus or commands
' ln_brent.uroot(adf)
' ln_gpr.uroot(adf)
' ln_ovx.uroot(adf)
' ln_eputrade.uroot(adf)

' Main ARDL/NARDL specification
' The manuscript reports ARDL(2,0,0,0,0,0,0) selected by SIC.
' In EViews, estimate ARDL with dependent ln_brent and regressors:
' gpr_pos gpr_neg gpr_pos_ru gpr_neg_ru gpr_pos_ir gpr_neg_ir

' Example command style may vary by EViews version:
' equation eq_nardl.ardl(deplags=2, reglags=0, criterion=sic) ln_brent gpr_pos gpr_neg gpr_pos_ru gpr_neg_ru gpr_pos_ir gpr_neg_ir

' Bounds test and ECM should be obtained from ARDL/NARDL output.

' Wald tests comparing event-context coefficients
' Adjust coefficient indices according to the final estimated equation.
' eq_nardl.wald c(5)=c(7)
' eq_nardl.wald c(6)=c(8)

' Robustness specifications
' Add ln_ovx and ln_eputrade as controls in separate ARDL/NARDL models.
' equation eq_ovx.ardl(deplags=2, reglags=0, criterion=sic) ln_brent gpr_pos gpr_neg gpr_pos_ru gpr_neg_ru gpr_pos_ir gpr_neg_ir ln_ovx
' equation eq_eputrade.ardl(deplags=2, reglags=0, criterion=sic) ln_brent gpr_pos gpr_neg gpr_pos_ru gpr_neg_ru gpr_pos_ir gpr_neg_ir ln_eputrade

' Diagnostics to report:
' Breusch-Godfrey LM, Breusch-Pagan-Godfrey, Jarque-Bera, Ramsey RESET, CUSUM, CUSUMSQ.
