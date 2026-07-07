package com.rql.healthmanage.view.ui.main

enum class MainTab(val title: String) {
    Home("首页"),
    Health("健康数据"),
    Sport("运动"),
    Social("社交"),
    Mine("我的")
}

object AppRoute {
    const val Checking = "checking"
    const val Login = "login"
    const val Register = "register"
    const val Main = "main"
    const val Assessment = "assessment"
    const val VideoList = "video_list"
    const val RecipeList = "recipe_list"
    const val VideoDetail = "video_detail"
    const val RecipeDetail = "recipe_detail"
    const val PostDetail = "post_detail"
}

