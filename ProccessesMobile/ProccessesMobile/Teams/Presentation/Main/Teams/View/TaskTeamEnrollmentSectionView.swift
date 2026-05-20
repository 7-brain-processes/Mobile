//
//  TaskTeamEnrollmentSectionView.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import SwiftUI

struct TaskTeamEnrollmentSectionView: View {
    let myTeam: StudentTeam?
    let teams: [CourseTeamAvailability]
    let distributionModeTitle: String?
    let votingStatusTitle: String?
    let votingPrompt: String?
    let ownGradeLabel: String?
    let votingActionTitle: String
    let voteStatus: TeamGradeVoteStatus?
    let isLoading: Bool
    let isLoadingVotingState: Bool
    let isChangingTeam: Bool
    let canOpenVoteSheet: Bool
    let onJoin: (CourseTeamAvailability) -> Void
    let onLeave: () -> Void
    let onOpenVoteSheet: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Teams")
                    .font(.headline)

                Spacer()

                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            if let myTeam {
                currentTeamCard(myTeam)
            } else {
                Text("You are not in a team yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if teams.isEmpty && !isLoading {
                Text("No teams available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(teams) { team in
                    teamRow(team)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func currentTeamCard(_ team: StudentTeam) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current team")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(team.teamName)
                .font(.subheadline)
                .fontWeight(.semibold)

            if let teamGrade = team.teamGrade {
                Text("Team grade: \(teamGrade)/100")
                    .font(.caption)
                    .foregroundStyle(.primary)
            }

            if let distributionModeTitle {
                Text("Distribution mode: \(distributionModeTitle)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let votingStatusTitle {
                Text("Voting status: \(votingStatusTitle)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let votingPrompt {
                Text(votingPrompt)
                    .font(.caption)
                    .foregroundStyle(.primary)
            }

            if let voteStatus {
                Text("Votes: \(voteStatus.votedCount)/\(voteStatus.voters.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let ownGradeLabel {
                Text(ownGradeLabel)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }

            Text("\(team.membersCount)/\(team.maxSize.map(String.init) ?? "∞") members")
                .font(.caption)
                .foregroundStyle(.secondary)

            if let voteStatus, voteStatus.finalized, !voteStatus.finalDistribution.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Final distribution")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ForEach(voteStatus.finalDistribution, id: \.student.id) { item in
                        Text("\(item.student.displayName): \(item.grade.map(String.init) ?? "-")/100")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                }
            }

            if isLoadingVotingState {
                ProgressView()
                    .scaleEffect(0.8)
            } else if canOpenVoteSheet {
                Button(votingActionTitle) {
                    onOpenVoteSheet()
                }
                .buttonStyle(.borderedProminent)
            }

            Button("Leave team", role: .destructive) {
                onLeave()
            }
            .buttonStyle(.bordered)
            .disabled(isChangingTeam)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func teamRow(_ team: CourseTeamAvailability) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text(team.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("\(team.currentMembers)/\(team.maxSize.map(String.init) ?? "∞") members")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let teamGrade = team.teamGrade {
                    Text("Team grade: \(teamGrade)/100")
                        .font(.caption)
                        .foregroundStyle(.primary)
                }

                if !team.categories.isEmpty {
                    Text(team.categories.map(\.title).joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                if team.isStudentMember {
                    Text("You are in this team")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else if team.isFull {
                    Text("Team is full")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else if !team.selfEnrollmentEnabled {
                    Text("Self-enrollment disabled")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button("Join") {
                onJoin(team)
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                isChangingTeam ||
                team.isFull ||
                !team.selfEnrollmentEnabled ||
                team.isStudentMember ||
                myTeam != nil
            )
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
