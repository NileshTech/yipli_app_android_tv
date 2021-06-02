enum Status { Accepted, Pending, Declined, Blocked }

class BuddyDetails {
  String playerId;
  String buddieAddDate;
  String status;
  BuddyDetails(this.playerId, this.buddieAddDate, this.status);
}
