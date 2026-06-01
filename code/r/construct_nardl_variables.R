# ================================================================
# R preprocessing template
# Manuscript: Event-Contextual Geopolitical Risk and Brent Oil Prices
# ================================================================

# install.packages(c("readxl", "dplyr", "writexl"))
library(readxl)
library(dplyr)
library(writexl)

# Adjust file path and sheet name after uploading data to GitHub
# raw <- read_excel("data/raw/eviews_used_data.xlsx")

# Expected columns:
# date, BRENT, GPR, RU_D, IR_D, OVX, EPUTRADE

construct_nardl_variables <- function(df) {
  df %>%
    arrange(date) %>%
    mutate(
      ln_brent = log(BRENT),
      ln_gpr = log(GPR),
      ln_ovx = log(OVX),
      ln_eputrade = log(EPUTRADE),
      d_lngpr = ln_gpr - lag(ln_gpr),
      gpr_pos_incr = if_else(d_lngpr > 0, d_lngpr, 0, missing = 0),
      gpr_neg_incr = if_else(d_lngpr < 0, d_lngpr, 0, missing = 0),
      gpr_pos = cumsum(gpr_pos_incr),
      gpr_neg = cumsum(gpr_neg_incr),
      gpr_pos_ru = gpr_pos * RU_D,
      gpr_neg_ru = gpr_neg * RU_D,
      gpr_pos_ir = gpr_pos * IR_D,
      gpr_neg_ir = gpr_neg * IR_D
    )
}

# processed <- construct_nardl_variables(raw)
# write_xlsx(processed, "data/processed/nardl_processed_variables.xlsx")
