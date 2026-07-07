package com.rql.healthmanage.model.datasource.local

import android.content.Context
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase

@Entity(tableName = "pending_health")
data class PendingHealthEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val dataType: Int,
    val payloadJson: String,
    val createdAt: Long,
    val synced: Boolean = false
)

@Dao
interface PendingHealthDao {
    @Query("SELECT * FROM pending_health WHERE synced = 0 ORDER BY createdAt ASC")
    suspend fun pending(): List<PendingHealthEntity>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(row: PendingHealthEntity): Long

    @Query("UPDATE pending_health SET synced = 1 WHERE id = :id")
    suspend fun markSynced(id: Long)
}

@Database(entities = [PendingHealthEntity::class], version = 1, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun pendingHealthDao(): PendingHealthDao

    companion object {
        @Volatile
        private var INSTANCE: AppDatabase? = null
        fun get(context: Context): AppDatabase =
            INSTANCE ?: synchronized(this) {
                INSTANCE ?: Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    "health_manage.db"
                ).build().also { INSTANCE = it }
            }
    }
}
