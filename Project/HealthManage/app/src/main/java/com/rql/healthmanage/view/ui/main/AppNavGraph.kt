package com.rql.healthmanage.view.ui.main

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.util.SPUtil
import com.rql.healthmanage.view.ui.auth.LoginScreen
import com.rql.healthmanage.view.ui.auth.RegisterScreen
import com.rql.healthmanage.view.ui.health.AssessmentQuestionnaireScreen
import com.rql.healthmanage.view.ui.home.RecipeDetailScreen
import com.rql.healthmanage.view.ui.home.RecipeListScreen
import com.rql.healthmanage.view.ui.home.VideoDetailScreenWithActions
import com.rql.healthmanage.view.ui.home.RecipeDetailScreenWithActions
import com.rql.healthmanage.view.ui.home.VideoListScreen
import com.rql.healthmanage.view.ui.social.PostDetailScreen
import com.rql.healthmanage.viewmodel.auth.AppAuthViewModel

@Composable
fun HealthManageAppEntry() {
    val navController = rememberNavController()
    var selectedTab by rememberSaveable { mutableStateOf(MainTab.Home) }
    var selectedVideo by remember { mutableStateOf<VideoItemDto?>(null) }
    var selectedRecipe by remember { mutableStateOf<RecipeItemDto?>(null) }
    var selectedPost by remember { mutableStateOf<SocialPostDto?>(null) }

    AppNavHost(
        navController = navController,
        selectedTab = selectedTab,
        onSelectTab = { selectedTab = it },
        selectedVideo = selectedVideo,
        onSelectVideo = { selectedVideo = it },
        selectedRecipe = selectedRecipe,
        onSelectRecipe = { selectedRecipe = it },
        selectedPost = selectedPost,
        onSelectPost = { selectedPost = it }
    )
}

@Composable
private fun AppNavHost(
    navController: NavHostController,
    selectedTab: MainTab,
    onSelectTab: (MainTab) -> Unit,
    selectedVideo: VideoItemDto?,
    onSelectVideo: (VideoItemDto) -> Unit,
    selectedRecipe: RecipeItemDto?,
    onSelectRecipe: (RecipeItemDto) -> Unit,
    selectedPost: SocialPostDto?,
    onSelectPost: (SocialPostDto) -> Unit,
    authVm: AppAuthViewModel = viewModel()
) {
    val loading by authVm.loading.observeAsState(false)
    val loginError by authVm.loginError.observeAsState()
    val registerError by authVm.registerError.observeAsState()
    val targetRoute by authVm.targetRoute.observeAsState()

    LaunchedEffect(targetRoute) {
        val route = targetRoute ?: return@LaunchedEffect
        when (route) {
            AppRoute.Main -> navController.navigate(AppRoute.Main) {
                popUpTo(AppRoute.Login) { inclusive = true }
                launchSingleTop = true
            }
            AppRoute.Login -> navController.navigate(AppRoute.Login) {
                popUpTo(AppRoute.Main) { inclusive = true }
                launchSingleTop = true
            }
            AppRoute.Register -> navController.navigate(AppRoute.Register)
        }
        authVm.consumeRoute()
    }

    NavHost(navController = navController, startDestination = AppRoute.Checking) {
        composable(AppRoute.Checking) {
            CheckingScreen(onCheck = { authVm.checkSession(AppRoute.Login, AppRoute.Main) })
        }
        composable(AppRoute.Login) {
            LoginScreen(
                initialAccount = SPUtil.getSavedLoginAccount(),
                initialPassword = if (SPUtil.isRememberPasswordEnabled()) SPUtil.getSavedLoginPassword() else "",
                initialRemember = SPUtil.isRememberPasswordEnabled(),
                loading = loading,
                error = loginError,
                onLogin = { account, password, rememberPassword ->
                    authVm.login(account, password, rememberPassword, AppRoute.Main)
                },
                onGoRegister = { navController.navigate(AppRoute.Register) }
            )
        }
        composable(AppRoute.Register) {
            RegisterScreen(
                loading = loading,
                error = registerError,
                onRegister = { username, password, phone, email, gender ->
                    authVm.register(username, password, phone, email, gender, AppRoute.Login)
                },
                onBackToLogin = { navController.popBackStack() }
            )
        }
        composable(AppRoute.Main) {
            MainContainer(
                selected = selectedTab,
                onSelect = onSelectTab,
                onLogout = { authVm.logout(AppRoute.Login) },
                onStartAssessment = { navController.navigate(AppRoute.Assessment) },
                onShowVideoList = { navController.navigate(AppRoute.VideoList) },
                onShowRecipeList = { navController.navigate(AppRoute.RecipeList) },
                onOpenVideo = { video -> onSelectVideo(video); navController.navigate(AppRoute.VideoDetail) },
                onOpenRecipe = { recipe -> onSelectRecipe(recipe); navController.navigate(AppRoute.RecipeDetail) },
                onOpenPost = { post -> onSelectPost(post); navController.navigate(AppRoute.PostDetail) }
            )
        }
        composable(AppRoute.Assessment) {
            AssessmentQuestionnaireScreen(
                onBack = { navController.popBackStack() },
                onCompleted = { navController.popBackStack() },
                onGoHealthData = {
                    onSelectTab(MainTab.Health)
                    navController.popBackStack()
                },
                onGoSportPlan = {
                    onSelectTab(MainTab.Sport)
                    navController.popBackStack()
                },
                onGoSportCheckIn = {
                    onSelectTab(MainTab.Sport)
                    navController.popBackStack()
                }
            )
        }
        composable(AppRoute.VideoList) {
            VideoListScreen(onBack = { navController.popBackStack() }, onOpenVideo = { video ->
                onSelectVideo(video)
                navController.navigate(AppRoute.VideoDetail)
            })
        }
        composable(AppRoute.RecipeList) {
            RecipeListScreen(onBack = { navController.popBackStack() }, onOpenRecipe = { recipe ->
                onSelectRecipe(recipe)
                navController.navigate(AppRoute.RecipeDetail)
            })
        }
        composable(AppRoute.VideoDetail) { VideoDetailScreenWithActions(video = selectedVideo, onBack = { navController.popBackStack() }) }
        composable(AppRoute.RecipeDetail) { RecipeDetailScreenWithActions(recipe = selectedRecipe, onBack = { navController.popBackStack() }) }
        composable(AppRoute.PostDetail) { PostDetailScreen(post = selectedPost, onBack = { navController.popBackStack() }) }
    }
}

@Composable
private fun CheckingScreen(onCheck: () -> Unit) {
    Column(
        Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        CircularProgressIndicator()
        Spacer(Modifier.height(8.dp))
        Text("正在检测登录状态...")
    }
    LaunchedEffect(Unit) { onCheck() }
}
