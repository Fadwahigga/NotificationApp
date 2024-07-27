<?php
// app/Http/Controllers/NotificationController.php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Events\NotificationEvent;

class NotificationController extends Controller
{
    public function send(Request $request)
    {
        $message = $request->input('message');
        event(new NotificationEvent($message));
        return response()->json(['success' => true]);
    }
}
