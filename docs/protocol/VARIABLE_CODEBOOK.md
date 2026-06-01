# Variable definitions and construction protocol

## Core variables

| Variable | Description | Frequency | Role |
|---|---|---:|---|
| BRENT | Brent crude oil price | Monthly | Dependent variable |
| GPR | Global Geopolitical Risk Index | Monthly | Main geopolitical risk variable |
| RU_D | Russia-Ukraine War period dummy | Monthly | Event-context moderator |
| IR_D | Iran-related tension period dummy | Monthly | Event-context moderator |
| OVX | Crude Oil Volatility Index | Monthly | Robustness/control variable |
| EPUTRADE | Trade Policy Uncertainty Index | Monthly | Robustness/control variable |

## Log transformations

`BRENT`, `GPR`, `OVX`, and `EPUTRADE` are used in logarithmic form in the manuscript.

## NARDL partial sums

```text
GPR_POS(t) = sum[j = 1,...,t] max(ΔlnGPR(j), 0)
GPR_NEG(t) = sum[j = 1,...,t] min(ΔlnGPR(j), 0)
```

## Event-contextual interactions

```text
GPR_POS_RU(t) = GPR_POS(t) × RU_D(t)
GPR_NEG_RU(t) = GPR_NEG(t) × RU_D(t)
GPR_POS_IR(t) = GPR_POS(t) × IR_D(t)
GPR_NEG_IR(t) = GPR_NEG(t) × IR_D(t)
```

## Main empirical model

The event-contextual NARDL model is estimated in an error-correction form:

```text
ΔlnBRENT(t) = α0 + λECM(t−1)
             + Σβi ΔlnBRENT(t−i)
             + Σγi ΔGPR_POS(t−i)
             + Σδi ΔGPR_NEG(t−i)
             + Σθi ΔGPR_POS_RU(t−i)
             + Σφi ΔGPR_NEG_RU(t−i)
             + Σμi ΔGPR_POS_IR(t−i)
             + Σηi ΔGPR_NEG_IR(t−i)
             + ε(t)
```

## Reported tests

- ADF, PP, KPSS, and Zivot-Andrews unit-root tests
- ARDL/NARDL bounds test
- Error-correction coefficient
- Long-run coefficients
- Wald tests comparing Russia-Ukraine and Iran interaction coefficients
- Serial correlation, heteroskedasticity, normality, Ramsey RESET, CUSUM, and CUSUMSQ diagnostics
- Robustness checks with OVX and EPUTRADE controls
