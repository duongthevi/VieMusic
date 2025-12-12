class ErrorHandler {
  static String mapError(String technicalError) {
    final String lowerError = technicalError.toLowerCase();

    // ============================================================
    // 1. LỖI MẠNG & KẾT NỐI (NETWORK)
    // ============================================================
    if (lowerError.contains('socket') ||
        lowerError.contains('connection') ||
        lowerError.contains('host lookup') ||
        lowerError.contains('network')) {
      return 'No internet connection. Please check your settings.';
    }
    if (lowerError.contains('timeout')) {
      return 'The request timed out. Please check your connection and try again.';
    }
    if (lowerError.contains('clientexception')) {
      return 'Unable to connect to the server. Please try again later.';
    }

    // ============================================================
    // 2. LỖI XÁC THỰC & TÀI KHOẢN (AUTH)
    // ============================================================
    // Đăng nhập sai
    if (lowerError.contains('failed to authenticate') || lowerError.contains('invalid identity')) {
      return 'Incorrect email or password.';
    }

    // Đăng ký - Email
    if (lowerError.contains('validation_invalid_email') || lowerError.contains('invalid email')) {
      return 'Invalid email address format.';
    }
    if (lowerError.contains('validation_not_unique') ||
        lowerError.contains('email') && (lowerError.contains('taken') || lowerError.contains('exists'))) {
      return 'This email is already registered. Please sign in.';
    }

    // Mật khẩu
    if (lowerError.contains('validation_length_mismatch') || lowerError.contains('password') && lowerError.contains('short')) {
      return 'Password must be at least 8 characters long.';
    }
    if (lowerError.contains('passwordconfirm') || lowerError.contains('not match')) {
      return 'Confirm password does not match.';
    }
    if (lowerError.contains('old password')) {
      return 'The old password is incorrect.';
    }

    // Session hết hạn
    if (lowerError.contains('unauthorized') || lowerError.contains('401')) {
      return 'Session expired. Please log in again.';
    }

    // ============================================================
    // 3. LỖI QUYỀN HẠN (PERMISSION / 403)
    // ============================================================
    if (lowerError.contains('forbidden') || lowerError.contains('403')) {
      // Thường xảy ra khi user cố sửa/xóa bài hát/playlist không phải của họ
      return 'You do not have permission to perform this action.';
    }

    // ============================================================
    // 4. LỖI DỮ LIỆU & VALIDATION (SONG, PLAYLIST, PROFILE)
    // ============================================================
    // Không tìm thấy (404)
    if (lowerError.contains('not found') || lowerError.contains('404')) {
      return 'The requested resource (Song, User, or Playlist) was not found.';
    }

    // Dữ liệu rỗng (Thường gặp khi tạo Playlist/Song mà quên nhập tên)
    if (lowerError.contains('validation_required') || lowerError.contains('cannot be empty')) {
      if (lowerError.contains('title')) return 'Title is required.';
      if (lowerError.contains('name')) return 'Name is required.';
      return 'Please fill in all required fields.';
    }

    // Lỗi File (Upload nhạc/ảnh)
    if (lowerError.contains('too large') || lowerError.contains('size limit')) {
      return 'The file is too large. Please choose a smaller file.';
    }
    if (lowerError.contains('validation_invalid_mime_type') || lowerError.contains('format')) {
      return 'Invalid file format. Please check your file.';
    }

    // Lỗi request sai (400) - Thường do code gửi data sai cấu trúc
    if (lowerError.contains('400') || lowerError.contains('bad request')) {
      return 'Invalid request data. Please contact support.';
    }

    // ============================================================
    // 5. LỖI HỦY BỎ & MẶC ĐỊNH
    // ============================================================
    if (lowerError.contains('canceled') || lowerError.contains('cancelled')) {
      return 'Request cancelled.';
    }

    // Nếu lỗi quá dài (lỗi raw từ server), trả về câu chung chung để tránh làm rối UI
    if (technicalError.length > 200) {
      return 'An unexpected error occurred. Please try again.';
    }

    // Trả về lỗi gốc nếu không bắt được case nào (để dev debug)
    return technicalError;
  }
}