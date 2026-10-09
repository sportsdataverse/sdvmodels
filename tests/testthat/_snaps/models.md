# xgboost print methods are stable

    Code
      print(xgboost::xgb.load.raw(cfb_ep_model))
    Output
      ##### xgb.Booster
      # of features: 8 
      # of rounds:  525 

---

    Code
      print(xgboost::xgb.load.raw(cfb_wp_spread_model))
    Output
      ##### xgb.Booster
      # of features: 13 
      # of rounds:  760 

---

    Code
      print(xgboost::xgb.load.raw(cfb_fd_model))
    Output
      ##### xgb.Booster
      # of features: 9 
      # of rounds:  157 

