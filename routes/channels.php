<?php

use Illuminate\Support\Facades\Broadcast;
Broadcast::channel('notifications', function ($user) {
    return true; // Replace with your authorization logic
});