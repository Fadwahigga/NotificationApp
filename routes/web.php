<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\NotificationController;

Route::get('/', function () {
    return view('welcome');
});
Route::get('/notification', function () {
    return view('notification');
});

Route::post('/send-notification', [NotificationController::class, 'send']);
