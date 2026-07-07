package com.rql.healthmanage.model.datasource.remote.api

import com.rql.healthmanage.common.result.ApiResult
import com.rql.healthmanage.model.entity.AiAdviceRequestDto
import com.rql.healthmanage.model.entity.AiAdviceResponseDto
import com.rql.healthmanage.model.entity.AssessmentEntityDto
import com.rql.healthmanage.model.entity.AssessmentEvaluateDto
import com.rql.healthmanage.model.entity.AssessmentQuestionDto
import com.rql.healthmanage.model.entity.CollaborativeEdgeDto
import com.rql.healthmanage.model.entity.AssessmentResultDto
import com.rql.healthmanage.model.entity.ConstitutionRequestDto
import com.rql.healthmanage.model.entity.ConstitutionResultDto
import com.rql.healthmanage.model.entity.HealthDataItemDto
import com.rql.healthmanage.model.entity.HealthDataListDto
import com.rql.healthmanage.model.entity.HealthDataRequestDto
import com.rql.healthmanage.model.entity.LoginRequestDto
import com.rql.healthmanage.model.entity.LoginResponseDto
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.model.entity.RegisterRequestDto
import com.rql.healthmanage.model.entity.SocialPostCreateDto
import com.rql.healthmanage.model.entity.SocialCommentCreateDto
import com.rql.healthmanage.model.entity.SocialCommentDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.SportPlanCreateDto
import com.rql.healthmanage.model.entity.SportPlanDto
import com.rql.healthmanage.model.entity.SportRecordCreateDto
import com.rql.healthmanage.model.entity.SportRecordDto
import com.rql.healthmanage.model.entity.SystemNoticeDto
import com.rql.healthmanage.model.entity.UpdatePasswordDto
import com.rql.healthmanage.model.entity.UpdateUserInfoDto
import com.rql.healthmanage.model.entity.UserInfoDto
import com.rql.healthmanage.model.entity.VideoItemDto
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Path
import retrofit2.http.Query

interface HealthApi {
    @POST("api/auth/login")
    suspend fun login(@Body body: LoginRequestDto): ApiResult<LoginResponseDto>

    @POST("api/auth/register")
    suspend fun register(@Body body: RegisterRequestDto): ApiResult<UserInfoDto?>

    @POST("api/auth/logout")
    suspend fun logout(): ApiResult<Boolean?>

    @PUT("api/auth/info")
    suspend fun updateUserInfo(@Body body: UpdateUserInfoDto): ApiResult<UserInfoDto?>

    @PUT("api/auth/password")
    suspend fun changePassword(@Body body: UpdatePasswordDto): ApiResult<Boolean?>

    @GET("api/auth/info")
    suspend fun getUserInfo(): ApiResult<UserInfoDto?>

    @GET("api/auth/users/search")
    suspend fun searchUsers(
        @Query("keyword") keyword: String,
        @Query("limit") limit: Int = 30
    ): ApiResult<List<UserInfoDto>?>

    @POST("api/health/data")
    suspend fun addHealthData(@Body body: HealthDataRequestDto): ApiResult<HealthDataItemDto?>

    @PUT("api/health/data/{dataId}")
    suspend fun updateHealthData(
        @Path("dataId") dataId: Int,
        @Body body: HealthDataRequestDto
    ): ApiResult<HealthDataItemDto?>

    @GET("api/health/data/list")
    suspend fun healthDataList(@Query("dataType") dataType: Int?, @Query("page") page: Int = 1, @Query("size") size: Int = 50): ApiResult<HealthDataListDto?>

    @DELETE("api/health/data/{id}")
    suspend fun deleteHealthData(@Path("id") id: Int): ApiResult<Boolean?>

    @GET("api/health/assessment/questions")
    suspend fun assessmentQuestions(): ApiResult<List<AssessmentQuestionDto>?>

    @POST("api/health/assessment/constitution")
    suspend fun constitution(@Body body: ConstitutionRequestDto): ApiResult<ConstitutionResultDto?>

    @POST("api/health/assessment/evaluate")
    suspend fun evaluate(@Body body: AssessmentEvaluateDto): ApiResult<AssessmentResultDto?>

    @GET("api/health/assessment/latest")
    suspend fun latestAssessment(): ApiResult<AssessmentEntityDto?>

    /** 基于最近一次已完成评估，返回等级、体质与匹配调理方案（用于「查看调理方案」） */
    @GET("api/health/assessment/latest-display")
    suspend fun latestAssessmentDisplay(): ApiResult<AssessmentResultDto?>

    @POST("api/health/ai/advice")
    suspend fun aiAdvice(@Body body: AiAdviceRequestDto): ApiResult<AiAdviceResponseDto?>

    @GET("api/recommendation/videos")
    suspend fun recommendVideos(
        @Query("limit") limit: Int = 10,
        @Query("constitution") constitution: String? = null,
    ): ApiResult<List<VideoItemDto>?>

    @GET("api/recommendation/recipes")
    suspend fun recommendRecipes(
        @Query("limit") limit: Int = 10,
        @Query("constitution") constitution: String? = null,
    ): ApiResult<List<RecipeItemDto>?>

    @GET("api/recommendation/collaborative-edges/videos")
    suspend fun videoCollaborativeEdges(): ApiResult<List<CollaborativeEdgeDto>?>

    @GET("api/recommendation/collaborative-edges/recipes")
    suspend fun recipeCollaborativeEdges(): ApiResult<List<CollaborativeEdgeDto>?>

    @POST("api/video/{id}/collect")
    suspend fun collectVideo(@Path("id") id: Int): ApiResult<Boolean?>

    @DELETE("api/video/{id}/collect")
    suspend fun uncollectVideo(@Path("id") id: Int): ApiResult<Boolean?>

    @POST("api/recipe/{id}/collect")
    suspend fun collectRecipe(@Path("id") id: Int): ApiResult<Boolean?>

    @DELETE("api/recipe/{id}/collect")
    suspend fun uncollectRecipe(@Path("id") id: Int): ApiResult<Boolean?>

    @POST("api/video/{id}/view")
    suspend fun reportVideoView(@Path("id") id: Int): ApiResult<Boolean?>

    @POST("api/recipe/{id}/view")
    suspend fun reportRecipeView(@Path("id") id: Int): ApiResult<Boolean?>

    @GET("api/system/notices")
    suspend fun notices(@Query("page") page: Int = 1, @Query("size") size: Int = 20): ApiResult<List<SystemNoticeDto>?>

    @GET("api/social/feed")
    suspend fun socialFeed(@Query("type") type: String = "recommend", @Query("page") page: Int = 1, @Query("size") size: Int = 20): ApiResult<List<SocialPostDto>?>
    @GET("api/social/post/{postId}")
    suspend fun getSocialPost(@Path("postId") postId: Int): ApiResult<SocialPostDto?>
    @GET("api/social/user/{targetUserId}/posts")
    suspend fun userPosts(@Path("targetUserId") targetUserId: Int, @Query("page") page: Int = 1, @Query("size") size: Int = 20): ApiResult<List<SocialPostDto>?>

    @POST("api/social/post")
    suspend fun createPost(@Body body: SocialPostCreateDto): ApiResult<Any?>

    @PUT("api/social/post/{postId}")
    suspend fun updateSocialPost(@Path("postId") postId: Int, @Body body: SocialPostCreateDto): ApiResult<Any?>

    @DELETE("api/social/post/{postId}")
    suspend fun deleteSocialPost(@Path("postId") postId: Int): ApiResult<Any?>

    @GET("api/social/my/comments")
    suspend fun mySocialComments(@Query("page") page: Int = 1, @Query("size") size: Int = 80): ApiResult<List<SocialCommentDto>?>

    @PUT("api/social/comment/{commentId}")
    suspend fun updateSocialComment(@Path("commentId") commentId: Int, @Body body: SocialCommentCreateDto): ApiResult<Any?>

    @DELETE("api/social/comment/{commentId}")
    suspend fun deleteSocialComment(@Path("commentId") commentId: Int): ApiResult<Any?>

    @POST("api/social/post/{postId}/like")
    suspend fun likePost(@Path("postId") postId: Int): ApiResult<Any?>

    @DELETE("api/social/post/{postId}/like")
    suspend fun unlikePost(@Path("postId") postId: Int): ApiResult<Any?>

    @POST("api/social/post/{postId}/collect")
    suspend fun collectSocialPost(@Path("postId") postId: Int): ApiResult<Any?>

    @DELETE("api/social/post/{postId}/collect")
    suspend fun uncollectSocialPost(@Path("postId") postId: Int): ApiResult<Any?>

    @GET("api/social/post/{postId}/comments")
    suspend fun socialComments(
        @Path("postId") postId: Int,
        @Query("page") page: Int = 1,
        @Query("size") size: Int = 20
    ): ApiResult<List<SocialCommentDto>?>

    @POST("api/social/post/{postId}/comment")
    suspend fun createComment(@Path("postId") postId: Int, @Body body: SocialCommentCreateDto): ApiResult<Any?>

    @POST("api/social/follow/{targetUserId}")
    suspend fun followUser(@Path("targetUserId") targetUserId: Int): ApiResult<Any?>

    @DELETE("api/social/follow/{targetUserId}")
    suspend fun unfollowUser(@Path("targetUserId") targetUserId: Int): ApiResult<Any?>

    @GET("api/social/following")
    suspend fun followingList(@Query("page") page: Int = 1, @Query("size") size: Int = 200): ApiResult<List<UserInfoDto>?>
    @GET("api/video/collected")
    suspend fun collectedVideos(): ApiResult<List<VideoItemDto>?>
    @GET("api/recipe/collected")
    suspend fun collectedRecipes(): ApiResult<List<RecipeItemDto>?>

    @GET("api/sport-plan/user/status")
    suspend fun sportPlansByStatus(@Query("status") status: Int): ApiResult<List<SportPlanDto>?>

    @GET("api/sport-plan/user")
    suspend fun sportPlansByUser(): ApiResult<List<SportPlanDto>?>

    @POST("api/sport-plan")
    suspend fun createSportPlan(@Body body: SportPlanCreateDto): ApiResult<SportPlanDto?>

    @PUT("api/sport-plan/{id}")
    suspend fun updateSportPlan(@Path("id") id: Int, @Body body: SportPlanCreateDto): ApiResult<SportPlanDto?>

    @DELETE("api/sport-plan/{id}")
    suspend fun deleteSportPlan(@Path("id") id: Int): ApiResult<Boolean?>

    @POST("api/sport-record")
    suspend fun createSportRecord(@Body body: SportRecordCreateDto): ApiResult<Any?>

    @GET("api/sport-record/plan/{planId}")
    suspend fun sportRecordsByPlan(@Path("planId") planId: Int): ApiResult<List<SportRecordDto>?>

    @GET("api/sport-record/user")
    suspend fun sportRecordsByUser(
        @Query("startDate") startDate: String = "2000-01-01",
        @Query("endDate") endDate: String = "2099-12-31"
    ): ApiResult<List<SportRecordDto>?>
}
