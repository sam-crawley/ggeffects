# select prediction method, based on model-object
#' @importFrom sjmisc add_variables
#' @importFrom insight find_response get_response get_data model_info link_inverse is_multivariate
select_prediction_method <- function(fun,
                                     model,
                                     expanded_frame,
                                     ci.lvl,
                                     type,
                                     faminfo,
                                     ppd,
                                     terms,
                                     typical,
                                     vcov.fun,
                                     vcov.type,
                                     vcov.args,
                                     condition,
                                     interval,
                                     ...) {
  # get link-inverse-function
  linv <- insight::link_inverse(model)
  if (is.null(linv)) linv <- function(x) x

  if (fun == "svyglm") {
    fitfram <- get_predictions_svyglm(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun == "svyglm.nb") {
    fitfram <- get_predictions_svyglmnb(model, expanded_frame, ci.lvl, linv, fun, typical, terms, vcov.fun, vcov.type, vcov.args, condition, interval, ...)
  } else if (fun == "stanreg") {
    fitfram <- get_predictions_stan(model, expanded_frame, ci.lvl, type, faminfo, ppd, terms, ...)
  } else if (fun == "brmsfit") {
    fitfram <- get_predictions_stan(model, expanded_frame, ci.lvl, type, faminfo, ppd, terms, ...)
  } else if (fun == "coxph" && type != "surv" && type != "cumhaz") {
    fitfram <- get_predictions_coxph(model, expanded_frame, ci.lvl, typical, fun, vcov.fun, vcov.type, vcov.args, condition, interval, ...)
  } else if (fun == "coxph" && type %in% c("surv", "cumhaz")) {
    fitfram <- get_predictions_survival(model, expanded_frame, ci.lvl, type, terms, ...)
  } else if (fun == "ols") {
    fitfram <- get_predictions_ols(model, expanded_frame, ci.lvl, ...)
  } else if (fun == "lrm") {
    fitfram <- get_predictions_lrm(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun == "glimML") {
    fitfram <- get_predictions_glimML(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun == "glmmTMB") {
    fitfram <- get_predictions_glmmTMB(model, expanded_frame, ci.lvl, linv, type, terms, typical, condition, ...)
  } else if (fun == "wbm") {
    fitfram <- get_predictions_wbm(model, expanded_frame, ci.lvl, linv, type, terms, typical, condition, ...)
  } else if (fun %in% c("lmer", "nlmer", "glmer")) {
    fitfram <- get_predictions_merMod(model, expanded_frame, ci.lvl, linv, type, terms, typical, condition, ...)
  } else if (fun == "geeglm") {
    fitfram <- get_predictions_geeglm(model, expanded_frame, ...)
  } else if (fun == "gamlss") {
    fitfram <- get_predictions_gamlss(model, expanded_frame, ci.lvl, linv, terms, fun, typical, condition, ...)
  } else if (fun == "gam") {
    fitfram <- get_predictions_gam(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun == "Gam") {
    fitfram <- get_predictions_Gam(model, expanded_frame, ci.lvl, linv, typical, terms, fun, condition, ...)
  # } else if (fun == "vgam") {
  # fitfram <- get_predictions_vgam(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun == "vglm") {
    fitfram <- get_predictions_vglm(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun == "tobit") {
    fitfram <- get_predictions_tobit(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun %in% c("lme", "gls", "plm")) {
    fitfram <- get_predictions_lme(model, expanded_frame, ci.lvl, linv, type, terms, typical, fun, vcov.fun, vcov.type, vcov.args, condition, ...)
  } else if (fun == "gee") {
    fitfram <- get_predictions_gee(model, terms, ...)
  } else if (fun == "multinom") {
    fitfram <- get_predictions_multinom(model, expanded_frame, ci.lvl, linv, typical, terms, fun, ...)
  } else if (fun == "clmm") {
    fitfram <- get_predictions_clmm(model, terms, typical, condition, ci.lvl, linv, ...)
  } else if (fun == "clm") {
    fitfram <- get_predictions_clm(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun == "clm2") {
    fitfram <- get_predictions_clm2(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun == "Zelig-relogit") {
    fitfram <- get_predictions_zelig(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun == "polr") {
    fitfram <- get_predictions_polr(model, expanded_frame, ci.lvl, linv, typical, terms, fun, vcov.fun, vcov.type, vcov.args, condition, interval, ...)
  } else if (fun %in% c("betareg", "truncreg", "ivreg", "vgam")) {
    fitfram <- get_predictions_generic2(model, expanded_frame, ci.lvl, linv, type, fun, typical, terms, vcov.fun, vcov.type, vcov.args, condition, interval, ...)
  } else if (fun %in% c("zeroinfl", "hurdle", "zerotrunc")) {
    fitfram <- get_predictions_zeroinfl(model, expanded_frame, ci.lvl, linv, type, fun, typical, terms, vcov.fun, vcov.type, vcov.args, condition, ...)
  } else if (fun %in% c("glm", "glm.nb")) {
    fitfram <- get_predictions_glm(model, expanded_frame, ci.lvl, linv, typical, fun, terms, vcov.fun, vcov.type, vcov.args, condition, interval, ...)
  } else if (fun %in% c("rq")) {
    fitfram <- get_predictions_rq(model, expanded_frame, ci.lvl, ...)
  } else if (fun %in% c("lmrob")) {
    fitfram <- get_predictions_lmrob_base(model, expanded_frame, ci.lvl, ...)
  } else if (fun %in% c("glmrob")) {
    fitfram <- get_predictions_glmrob_base(model, expanded_frame, ci.lvl, linv, ...)
  } else if (fun %in% c("glmRob")) {
    fitfram <- get_predictions_glmRob(model, expanded_frame, ci.lvl, linv, typical, fun, terms, vcov.fun, vcov.type, vcov.args, condition, interval, ...)
  } else if (fun == "logistf") {
    fitfram <- get_predictions_logistf(model, expanded_frame, terms, ...)
  } else if (fun == "lm") {
    fitfram <- get_predictions_lm(model, expanded_frame, ci.lvl, fun, typical, terms, vcov.fun, vcov.type, vcov.args, condition, interval, ...)
  } else if (fun == "MixMod") {
    fitfram <- get_predictions_MixMod(model, expanded_frame, ci.lvl, linv, type, terms, typical, condition, ...)
  } else if (fun == "MCMCglmm") {
    fitfram <- get_predictions_MCMCglmm(model, expanded_frame, ci.lvl, interval, ...)
  } else {
    fitfram <- get_predictions_generic(model, expanded_frame, linv, ...)
  }

  fitfram
}


get_base_fitfram <- function(model, fitfram, linv, prdat, se, ci.lvl, fun, typical, terms, vcov.fun, vcov.type, vcov.args, condition = NULL, interval = NULL) {

  # compute ci, two-ways

  if (!is.null(ci.lvl) && !is.na(ci.lvl))
    ci <- (1 + ci.lvl) / 2
  else
    ci <- .975


  # copy predictions

  if (typeof(prdat) == "double")
    .predicted <- prdat
  else
    .predicted <- prdat$fit


  # get standard errors, if computed

  if (obj_has_name(prdat, "se.fit")) {
    se.fit <- prdat$se.fit
    # reset interval, since we have normal confidence intervals already here
    if (interval == "confidence") interval <- NULL
  } else {
    se.fit <- NULL
  }

  # get predicted values, on link-scale
  fitfram$predicted <- .predicted

  # did user request robust standard errors?

  if (!is.null(vcov.fun) || (!is.null(interval) && se)) {
    se.pred <-
      get_se_from_vcov(
        model = model,
        fitfram = fitfram,
        typical = typical,
        terms = terms,
        fun = fun,
        vcov.fun = vcov.fun,
        vcov.type = vcov.type,
        vcov.args = vcov.args,
        condition = condition,
        interval = interval
      )

    if (!is.null(se.pred)) {
      fitfram <- se.pred$fitfram
      se.fit <- se.pred$se.fit
      se <- TRUE
    } else {
      se.fit <- NULL
      se <- FALSE
    }
  } else {
    se.pred <- NULL
  }


  # did user request standard errors? if yes, compute CI

  if (se && !is.null(se.fit)) {
    fitfram$conf.low <- linv(fitfram$predicted - stats::qnorm(ci) * se.fit)
    fitfram$conf.high <- linv(fitfram$predicted + stats::qnorm(ci) * se.fit)
    # copy standard errors
    attr(fitfram, "std.error") <- se.fit
    if (!is.null(se.pred))
      attr(fitfram, "prediction.interval") <- attr(se.pred, "prediction_interval")
  } else {
    # No CI
    fitfram$conf.low <- NA
    fitfram$conf.high <- NA
  }

  # transform predicted values
  fitfram$predicted <- linv(fitfram$predicted)

  fitfram
}
